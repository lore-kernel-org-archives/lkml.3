Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3LSQ4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:56:49 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:50410 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3LSQ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:56:47 -0500
Date: Thu, 19 Dec 2013 17:56:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] don't select EFI from certain special ACPI drivers
Message-ID: <20131219165643.GA30382@gmail.com>
References: <52AF1EBC020000780010DBF9@nat28.tlf.novell.com>
 <3908561D78D1C84285E8C5FCA982C28F31D8A4C2@ORSMSX106.amr.corp.intel.com>
 <52B013E8020000780010E009@nat28.tlf.novell.com>
 <3908561D78D1C84285E8C5FCA982C28F31D8B8CE@ORSMSX106.amr.corp.intel.com>
 <52B16533020000780010E890@nat28.tlf.novell.com>
 <CA+8MBb+7e03UxmJCnXSDh=8m+9LFT2R3h0v6g-wDWnn=N8vFWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+7e03UxmJCnXSDh=8m+9LFT2R3h0v6g-wDWnn=N8vFWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@intel.com> wrote:

> On Wed, Dec 18, 2013 at 12:04 AM, Jan Beulich <JBeulich@suse.com> wrote:
> >>>> On 17.12.13 at 23:34, "Luck, Tony" <tony.luck@intel.com> wrote:
> >>>  No, it hasn't. But I explicitly checked the relevant EFI=n and EFI=y
> >>> cases.
> >>
> >> I pushed your patch into my "next" tree - the robots will notice soon and
> >> send us e-mail if they find any issues.
> >
> > Thanks, Tony. I'm afraid though that fixing this only in 3.14 would
> > be a little late: Any "select" in a Kconfig results in the user not being
> > asked again when that "select" goes away, so people having got EFI
> > forcibly enabled in 3.13 and updating their configs to 3.14 would
> > then need to remember to manually disable CONFIG_EFI again (of
> > course that's already true for anyone using 3.13-rc?, but those
> > should mostly be people more knowledgeable than folks just
> > consuming final releases).
> >
> > I think it should generally be the exception to "select" options that
> > have visible prompts (i.e. are user configurable).
> 
> Ingo: Jan makes a good point that people running "make oldconfig"
> may get suckered into selecting CONFIG_EFI when they don't really
> need it.  I've not seen any complaints from the robot randconfig testers,
> so this patch is:
> 
> Acked-by: Tony Luck <tony.luck@intel.com>
> 
> Can you push it to Linus before 3.13-final releases?

Ok, agreed, I've queued it up in the tip:x86/urgent tree.

Thanks,

	Ingo
