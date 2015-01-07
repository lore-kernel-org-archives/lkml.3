Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbbAGCI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:08:59 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:53032 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbbAGCHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:49 -0500
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 21:07:49 EST
Date: Tue, 6 Jan 2015 20:00:03 -0600
From: David Fries <David@Fries.net>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] w1: slaves: w1_therm: Add temp attribute
Message-ID: <20150107020003.GJ2522@spacedout.fries.net>
References: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
 <1420554596-10250-3-git-send-email-marius.gorski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420554596-10250-3-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Tue, 06 Jan 2015 20:00:03 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 03:29:56PM +0100, Mariusz Gorski wrote:
> Add new attribute to simplify reading of current temperature.

> +static ssize_t temp_show(struct device *device,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct w1_slave *sl = dev_to_w1_slave(device);
> +	struct w1_master *dev = sl->master;
> +	u8 rom[9], verdict;
> +	int temp;
> +
> +	if (mutex_lock_interruptible(&dev->bus_mutex))
> +		return -EINTR;
> +
> +	memset(rom, 0, sizeof(rom));
> +
> +	verdict = read_rom(device, rom);
> +
> +	if (verdict < 0)
> +		return verdict;

I wanted to point out that this returns without unlocking bus_mutex.

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
