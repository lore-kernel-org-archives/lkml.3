Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaKHPyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 10:54:49 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:42664 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaKHPyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 10:54:47 -0500
MIME-Version: 1.0
In-Reply-To: <20141108130556.GM3592@console-pimps.org>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com> <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
 <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
 <CALCETrW1UaOCcb-32SOUhi_Zh5vLzV+VwyffThVvso23z04SHA@mail.gmail.com>
 <20141104154017.GA28113@kroah.com> <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
 <20141108130556.GM3592@console-pimps.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 8 Nov 2014 07:54:25 -0800
Message-ID: <CALCETrVaSKH_zChUzVFSqU7NCD9DtdeYDZF3GVKuxQDe607p0w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
To: Matt Fleming <matt@console-pimps.org>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 8, 2014 5:05 AM, "Matt Fleming" <matt@console-pimps.org> wrote:
>
> On Tue, 04 Nov, at 08:35:40AM, Andy Lutomirski wrote:
> >
> > Am I missing something here?  The current proposal is missing the
> > success/failure part, unless you count the loaded count (in a
> > different sysfs directory) as a useful interface for that.
>
> As Wilson pointed out, you only get the ability to make meaningful
> success/failure declarations once you've performed the reboot.
>
> I know of no firmware that will hot-patch itself when you call
> UpdateCapsule(). A reboot is always required. Certainly that's the way
> Windows will work from what I've read, which means that for x86 it's
> pretty much set in stone.

I dunno.  If nothing else, efi_capsule_update can fail due to ENOMEM.

>
> Which means there's only so much info you can return to userspace once
> you've handed the blob to the firmware. I don't see a huge problem with
> printing things in kernel buffer, since that's how other
> firmware-related things work today.

I think the kernel log is fine.  But if the code is going to report
success / failure to userspace at all, shouldn't that indication be
reliable?

TBH, I find this discussion very strange.  In summary:

me: This API is really awkward.

others: But it's using the subsystem that it should be using.

me: Then fix the subsystem?

others: The subsystem the correct choice.

me: But the API is still really awkward, and, by the way, it probably
has at least two races that user code could hit.  And, by the way, the
sample script written by the author of the patches is subject to
*both* races most likely and therefore won't work reliably.

you: Common use cases (e.g. Windows-style uses, perhaps) don't need
the features that are racy anyway.


My only response is that (a) something else might want the full
functionality and (b) Wilson's actual example script exercises the
racy code.

I think I'm done reviewing these patches.  I'll probably grumble at
the result the first time I actually try to install an EFI capsule,
though.

--Andy

P.S. What happens when a strange UEFI BIOS really wants two capsules,
and the second one will brick the machine if the first one isn't
there, and the first one failed to load but no one noticed because
there's no useful error handling?
