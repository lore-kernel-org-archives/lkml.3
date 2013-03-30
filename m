Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3C3UOI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 16:14:08 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:20703 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab3C3UOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 16:14:07 -0400
Date: Sat, 30 Mar 2013 21:13:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6]  Make return type of i2c_del_adapter() (and
 i2c_del_mux_adapter()) void
Message-ID: <20130330211352.07530db7@endymion.delvare>
In-Reply-To: <1362853009-20789-1-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Sat,  9 Mar 2013 19:16:43 +0100, Lars-Peter Clausen wrote:
> Currently i2c_del_adapter() returns 0 on success and potentially an error code
> on failure. Unfortunately this doesn't mix too well with the Linux device driver
> model. (...)

I see:

struct device_driver {
	(...)
	int (*probe) (struct device *dev);
	int (*remove) (struct device *dev);

So the driver core does allow remove functions to return an error. Are
you going to fix all subsystems as you are doing for i2c now, and then
change device_driver.remove to return void? If not, I don't see the
point of changing it in i2c.

-- 
Jean Delvare
