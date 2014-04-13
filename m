Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaDMQJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 12:09:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58387 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaDMQJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 12:09:38 -0400
Date: Sun, 13 Apr 2014 18:09:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Jacob Shin <jacob.shin@amd.com>, Jeff Layton <jlayton@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: microcode: report if CPU has up-to-date
 microcode
Message-ID: <20140413160924.GH25088@pd.tnic>
References: <1396188574-2067-1-git-send-email-dvlasenk@redhat.com>
 <20140331162340.GB16144@pd.tnic>
 <5339A0F8.70606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5339A0F8.70606@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 07:08:08PM +0200, Denys Vlasenko wrote:
> What prompted me to create this patch is a bunch of vmcores
> from people having mysterious crashes.
> 
> Basically, I am in a real-world scenario where I have only vmcore
> from somebody else. I have no /proc/cpuinfo.
> 
> Every bit of information I don't have at a minimum incurs email
> round-trip delay.
> 
> Eventually I did manage to figure out what version of microcode
> my users had (they did have old one), but it took some time.

Out of curiosity: the old microcode version wasn't the culprit for the
bug, was it?

> You are correct, the lack of boot-time dmesg is a problem for
> post-mortem vmcore analysis in general.
> 
> I contemplate creating a patch to optionally save it.

Btw, can vmcore stash ucode version somewhere too, as part of the data
dump it saves? Or even the whole /proc/cpuinfo?

> That is not a bad thing: if my users would have been spooked that
> way, maybe they'd install a newer microcode. Or newer BIOS with new
> microcode - they did not do that either, despite it being available
> from the manufacturer for two years already.

Right, ok. So in thinking about this more. How about we drop the "bool
report_old" machinery and add those printks as debug printks? And by
that I mean,

	printk(KERN_DEBUG...

and not all that other pr_debug() gunk?

This way, you need to boot with "debug" or "ignore_loglevel" on the
cmdline and they will get issued.

My concern is still with spooked users who'll come and say, my machine says:

+			pr_info("microcode: CPU rev 0x%x is same or newer"
+				" than 0x%x in microcode data\n",

Does that mean, I need to go and replace my CPU?

The usual case is that microcode gets upgraded with system upgrade as a
intel-ucode or amd-ucode or whatever package, so people upgrading their
distros will always get the latest ucode anyway.

Hmmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
