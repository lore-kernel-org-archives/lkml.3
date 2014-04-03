Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162327AbaDCGaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:30:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:32805 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161716AbaDCGax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,784,1389772800"; 
   d="scan'208";a="513885013"
Message-ID: <533D001A.5030802@linux.intel.com>
Date: Thu, 03 Apr 2014 14:30:50 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: FW: [BUG] x86: reboot doesn't reboot
References: <20140403021411.6236996f@gandalf.local.home> <070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
In-Reply-To: <070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Thursday, April 03, 2014 2:14 PM
> To: Linus Torvalds; LKML
> Cc: Ingo Molnar; H. Peter Anvin; Thomas Gleixner; Li, Aubrey; Matthew Garrett
> Subject: [BUG] x86: reboot doesn't reboot
>
> I noticed that one of my test boxes no longer does a reboot with the latest
> kernel. It goes down and shows:
>
> [   51.589896] reboot: Restarting system
> [   51.593567] reboot: machine restart
>
>
> And the system sounds like it turns off (the fans stop), but then I just sit there
> and wait, and wait and wait. The system never starts up again.
>
> I did a bisect and it landed on: a4f1987e4c54 "x86, reboot: Add EFI and
> CF9 reboot methods into the default list" which looks like a very likely suspect. I
> removed that and fb3bd7b19b2b, as the second commit was just a fix up of the
> first, recompiled, installed and rebooted to that kernel. I tried to reboot again
> and sure enough after posting the "machine restart" I started getting those
> "Press any key to continue."
> messages again. That's a good sign.
>
> Linus mentioned to me to use "reboot=pci" on the kernel command line, but no
> dice. That doesn't seem to make a difference.

May I know if "reboot=t" make any difference on your system with the change?

Thanks,
-Aubrey
