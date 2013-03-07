Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab3CGGAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:00:51 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42923 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3CGGAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:00:49 -0500
Date: Thu, 7 Mar 2013 14:01:17 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Brown <davidb@codeaurora.org>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] platform-drivers: msm: add single-wire serial bus
 interface (SSBI) driver
Message-ID: <20130307060117.GA31687@kroah.com>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
 <1362616187-21089-2-git-send-email-davidb@codeaurora.org>
 <20130307013008.GA2910@kroah.com>
 <8yawqtjvl8y.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8yawqtjvl8y.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 09:20:45PM -0800, David Brown wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > On Wed, Mar 06, 2013 at 04:29:42PM -0800, David Brown wrote:
> >> +menu "Qualcomm MSM SSBI bus support"
> >> +	depends on ARCH_MSM
> >
> > Why?
> 
> In the sense that ARCH_MSM are the only devices that ever were, or ever
> will be made with this device.  It doesn't strictly depend on it, but do
> we want to clutter the config for everything else.

It's not "clutter".  You want me to build this on other platforms, to
catch api and other types of build breakages.  This is the way for
almost all Linux drivers.

> >> +config MSM_SSBI
> >> +	bool "Qualcomm Single-wire Serial Bus Interface (SSBI)"
> >
> > Why can't this be a module?
> 
> Without this device, the PMIC drivers won't work, regulators can't be
> turned on, and most of the other devices won't work.  I can try if it
> can still be made a module, and it might be good at exercising the
> deferred probe mechanism.

If the PMIC drivers are dependant on the symbols in this module, there
should not be any problems, right?

> So, a deeper question.  I've resent this driver with minimal change.
> I've also made some other changes as patches afterwards.  Do we want
> these squashed into a single patch, or the initial one (not authored by
> me) followed by updates?

To preserve the authorship, you might want to fix this stuff with
follow-on patches.  As long as the original patch can build properly.

> >> +static struct platform_driver msm_ssbi_driver = {
> >> +	.probe		= msm_ssbi_probe,
> >> +	.remove		= __exit_p(msm_ssbi_remove),
> >
> > You just oopsed if someone unbound your device from the driver from
> > userspace.  Not good.
> 
> I did catch this one in a later patch :-)  I can clean it up in the
> driver, though, since it looks like some more work needs to go into
> this.

Yes, but it's very close, fix this all up and resend your series and all
should be fine.

Nice job,

greg k-h
