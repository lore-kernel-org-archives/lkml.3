Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbbARRwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 12:52:51 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36543 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbARRwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 12:52:47 -0500
Date: Sun, 18 Jan 2015 09:52:42 -0800
From: Darren Hart <dvhart@infradead.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: mjg59@srcf.ucam.org, pali.rohar@gmail.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, A.Sloman@cs.bham.ac.uk,
        computersforpeace@gmail.com
Subject: Re: [PATCH] dell-laptop: use dedicated sysfs file for ALS
Message-ID: <20150118175241.GA56582@vmdeb7>
References: <1421244357-31103-1-git-send-email-gabriele.mzt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421244357-31103-1-git-send-email-gabriele.mzt@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 03:05:57PM +0100, Gabriele Mazzotta wrote:
> The ambient light sensor doesn't act like an input trigger, so it has
> to be kept separate. The sensor readings are used to determine whether
> the conditions to change the keyboard illumination are satisfied or
> not the moment an input trigger is used. Ambient light changes alone
> can't change the keyboard backlight illumination and don't restart the
> timer.
> 
> Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> ---

...

> +static ssize_t kbd_led_als_enabled_store(struct device *dev,
> +					 struct device_attribute *attr,
> +					 const char *buf, size_t count)
> +{
> +	struct kbd_state new_state;
> +	struct kbd_state state;
> +	bool triggers_enabled = false;
> +	int enable;
> +	int ret;
> +
> +	if (!kbd_als_supported) {
> +		pr_warn("ALS mode is not supported\n");
> +		return -ENODEV;


Will this sysfs file exist if !kbd_als_supported? If so, can we prevent that?

...

Generally speaking, there is a lot more change here than I would like for an
RC5. I'm going to have to consider this one carefully. If we can't come up with
a simpler fix for this RC series, we may have to revert the previous patch and
target this for 3.20.

-- 
Darren Hart
Intel Open Source Technology Center
