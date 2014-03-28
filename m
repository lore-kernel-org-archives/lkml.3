Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaC1Ibb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:31:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaC1Ib3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:31:29 -0400
Message-ID: <1395995486.9520.2.camel@linux-fkkt.site>
Subject: Re: [PATCH v5 1/3] mfd: Add realtek USB card reader driver
From: Oliver Neukum <oneukum@suse.de>
To: Roger <rogerable@realtek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Date: Fri, 28 Mar 2014 09:31:26 +0100
In-Reply-To: <5334ED70.6050309@realtek.com>
References: <1395744293-24398-1-git-send-email-rogerable@realtek.com>
		 <1395744293-24398-2-git-send-email-rogerable@realtek.com>
	 <201403280231.s2S2VP8X017745@rtits1.realtek.com>
	 <5334ED70.6050309@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 11:33 +0800, Roger wrote:
> On 03/26/2014 10:36 PM, Oliver Neukum wrote:
> > On Tue, 2014-03-25 at 18:44 +0800, rogerable@realtek.com wrote:
> >> From: Roger Tseng <rogerable@realtek.com>

> >> +	if (ret)
> >> +		goto out_init_fail;
> >> +
> >> +	/* initialize USB SG transfer timer */
> >> +	init_timer(&ucr->sg_timer);
> >> +	setup_timer(&ucr->sg_timer, rtsx_usb_sg_timed_out, (unsigned long) ucr);
> >> +#ifdef CONFIG_PM
> >> +	intf->needs_remote_wakeup = 1;
> >
> > Why?
> Our reader supports remote wake-up from card slot event(insertion, 
> removal). It should be enabled to let the driver be able to detect the 
> newly inserted card.

Interesting. This capability has been lacking for a long time.
That is cool hardware. Are you sure the upper layers implement
the event infrastructure so that devices are not polled?

> The LED is not in a permanent cut-off state after here. It is called to 
> guarantee the LED is off during suspend to save more power. It could be 
> lit up in the card host drivers(e.g. rtsx_usb_sdmmc.c) anytime whenever 
> necessary.
> 
> This has been asked may times. I'm considering putting some comment in 
> next revision.

Good idea.

	Regards
		Oliver


