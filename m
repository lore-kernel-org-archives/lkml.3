Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaKHNGB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:06:01 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43285 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaKHNF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:05:59 -0500
Date: Sat, 8 Nov 2014 13:05:56 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Message-ID: <20141108130556.GM3592@console-pimps.org>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com>
 <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
 <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
 <CALCETrW1UaOCcb-32SOUhi_Zh5vLzV+VwyffThVvso23z04SHA@mail.gmail.com>
 <20141104154017.GA28113@kroah.com>
 <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov, at 08:35:40AM, Andy Lutomirski wrote:
> 
> Am I missing something here?  The current proposal is missing the
> success/failure part, unless you count the loaded count (in a
> different sysfs directory) as a useful interface for that.
 
As Wilson pointed out, you only get the ability to make meaningful
success/failure declarations once you've performed the reboot.

I know of no firmware that will hot-patch itself when you call
UpdateCapsule(). A reboot is always required. Certainly that's the way
Windows will work from what I've read, which means that for x86 it's
pretty much set in stone.

Which means there's only so much info you can return to userspace once
you've handed the blob to the firmware. I don't see a huge problem with
printing things in kernel buffer, since that's how other
firmware-related things work today.

-- 
Matt Fleming, Intel Open Source Technology Center
