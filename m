Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaIIAJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:09:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaIIAJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:09:12 -0400
Date: Mon, 8 Sep 2014 17:09:08 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] toshiba_acpi: Fix illumination not available on
 certain models
Message-ID: <20140909000908.GD5835@vmdeb7>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
 <1409937247-2525-3-git-send-email-coproscefalo@gmail.com>
 <20140906023537.GA11389@vmdeb7>
 <CAGdLNWHRU9sD9Ot2RcmEXA0HdLuQ=r=mYPsiS1SMcwwuxfpEeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdLNWHRU9sD9Ot2RcmEXA0HdLuQ=r=mYPsiS1SMcwwuxfpEeQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 10:49:09PM -0600, Azael Avalos wrote:
> Hi there
> 
> 2014-09-05 20:35 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> > On Fri, Sep 05, 2014 at 11:14:04AM -0600, Azael Avalos wrote:
> >> Some Toshiba models with illumination support set a different
> >> value on the returned codes, thus not allowing the illumination
> >> LED to be registered, where it should be.
> >>
> >> This patch removes a check from toshiba_illumination_available
> >> function to allow such models to register the illumination LED.
> >>
> >> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> >> ---
> >>  drivers/platform/x86/toshiba_acpi.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> >> index a149bc6..4803e7b 100644
> >> --- a/drivers/platform/x86/toshiba_acpi.c
> >> +++ b/drivers/platform/x86/toshiba_acpi.c
> >> @@ -436,7 +436,7 @@ static int toshiba_illumination_available(struct toshiba_acpi_dev *dev)
> >>       if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
> >>               pr_err("ACPI call to query Illumination support failed\n");
> >>               return 0;
> >> -     } else if (out[0] == HCI_NOT_SUPPORTED || out[1] != 1) {
> >> +     } else if (out[0] == HCI_NOT_SUPPORTED) {
> >
> > OK, but by eliminating the check, supposedly certain models which do not support
> > illumination but do not report it via out[0], but instead via out[1], will now
> > attempt to use illumination - correct?
> 
> Oh no, the main check is out[0], which either hold success if the
> feature is supported
> or an HCI/SCI error otherwise.
> 
> >
> > The end result being user calls to an ACPI function which at best doesn't exist
> > and at worst.... does, but does something entirely different.
> >
> > I admit the potential for a problem is slight, but is it possible to check
> > something explicit for support on the newer models rather than removing an
> > existing check?
> 
> Our only resource right now is the DSDT and actual hardware to test,
> as those calls
> are not documented anywhere, and everytime the vendor decides to
> change something,
> we're on the loose end.
> 
> All the DSDTs that I previously had all set out[1] to one, so I was
> using that as an
> extra check to make sure we had illumination support, but now, recent models
> set out[1] to zero, and those models, which do happen to have illumination
> support (Qosmio X75 for example) were failing to register the LED.

OK, I've been warned about taking non-obvious changes here. However, as you were
the original author here and are effectively telling me you want to revert the
out[1] check as it breaks hardware, I'm queueing this patch.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
