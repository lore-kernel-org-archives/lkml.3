Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3JRBFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:05:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3JRBFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:05:17 -0400
Date: Thu, 17 Oct 2013 21:05:09 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: usb_phy_gen: refine conditional declaration of
 usb_nop_xceiv_register
Message-ID: <20131018010508.GO16287@hansolo.jdub.homelinux.org>
References: <1381976321-11547-1-git-send-email-linux@roeck-us.net>
 <20131017172548.GM16287@hansolo.jdub.homelinux.org>
 <20131017203147.GA22947@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017203147.GA22947@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 01:31:47PM -0700, Guenter Roeck wrote:
> On Thu, Oct 17, 2013 at 01:25:48PM -0400, Josh Boyer wrote:
> > On Wed, Oct 16, 2013 at 07:18:41PM -0700, Guenter Roeck wrote:
> > > Commit 3fa4d734 (usb: phy: rename nop_usb_xceiv => usb_phy_gen_xceiv)
> > > changed the conditional around the declaration of usb_nop_xceiv_register
> > > from
> > > 	#if defined(CONFIG_NOP_USB_XCEIV) ||
> > > 		(defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
> > > to
> > > 	#if IS_ENABLED(CONFIG_NOP_USB_XCEIV)
> > > 
> > > While that looks the same, it is semantically different. The first expression
> > > is true if CONFIG_NOP_USB_XCEIV is built as module and if the including
> > > code is built as module. The second expression is true if code depending on
> > > CONFIG_NOP_USB_XCEIV if built as module or into the kernel.
> > > 
> > > As a result, the arm:allmodconfig build fails with
> > > 
> > > arch/arm/mach-omap2/built-in.o: In function `omap3_evm_init':
> > > arch/arm/mach-omap2/board-omap3evm.c:703: undefined reference to
> > > 	`usb_nop_xceiv_register'
> > > 
> > > Fix the problem by reverting to the old conditional.
> > > 
> > > Cc: Josh Boyer <jwboyer@redhat.com>
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > 
> > I'm not entirely sure why I was CC'd on this one, but the patch looks
> > good to me.  I do wonder how many other uses of IS_ENABLED aren't taking
> > this into account though.
> > 
> Unless I am wrong, you submitted a different patch to fix the same problem,
> which went nowhere, so I figured it was appropriate to Cc: you on this one.
> If not, my apologies.

Ah, so I did!  Amazing what I can forget in a month.

> As for other use cases of IS_ENABLED, agreed, that may be an ongoing concern. 
> That will have to be addressed individually, though.

Yep.

josh
