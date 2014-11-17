Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaKQX66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:58:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52623 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaKQX64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:58:56 -0500
Date: Tue, 18 Nov 2014 00:58:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephane Eranian <eranian@google.com>, x86-ml <x86@kernel.org>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, kan.liang@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v3 13/13] perf/x86: add syfs entry to disable HT bug
 workaround
Message-ID: <20141117235841.GD25157@pd.tnic>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
 <1416251225-17721-14-git-send-email-eranian@google.com>
 <20141117230232.GC25157@pd.tnic>
 <alpine.DEB.2.11.1411180025270.3909@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411180025270.3909@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 12:38:14AM +0100, Thomas Gleixner wrote:
> Well a bitmask is a pretty indescriptive item as well. Putting my user
> hat on: Where is the documentation for the bits?

$ cat /sys/devices/system/cpu/bugs
0xXXXXXX - currently enabled workarounds are the set bits.
bit 0: workaround for bug#blabla
bit 1: workaround for bug#1
bit 2: workaround for bug#2; remember to do <bla> before disabling workaround
...
bits n-63 are reserved, cannot be set and RAZ.

This will be issued when user cats the sysfs file.

> I'm not sure about that. Its a CPU bug at the very end. We should not
> care much which of the various bits and pieces of a CPU it affects and
> some of them affect more than one ....
> 
> But OTOH, we dont want to have random entries with impossible to
> understand file names under /sys/devices/cpu/ either.
> 
> So what about adding:
> 
>  /sys/devices/cpu/bugs/
>  
> and collect the various user tweakable (or not) bug data there.
> 
> So for the problem at hand:
> 
>  /sys/devices/cpu/bugs/ht_some_sensible_name/
> 
>    Directory
> 
>  /sys/devices/cpu/bugs/ht_some_sensible_name/info
> 
>    File, which describes the bug comprehensive. URL reference, Errata
>    Nr. or something like that.
> 
>  /sys/devices/cpu/bugs/ht_some_sensible_name/workaround
> 
>    File, to retrieve the status of the workaround. Possibly RO
>    depending on the nature of the issue.

Yes, that could be an alternative scheme to the one I'm proposing above.
But the one above is easier to implement and should contain enough info
to find the bug number in the relevant revision guide/doc update.

> > You should be adding this dynamically, only when running on Intel, i.e.
> > 
> > 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
> > 		/* add bug_workaround attr */
> 
> and if it's a family/model specific issue, we don't want to see it if
> we are not running on such a machine.

Yep.

> Given the fact that the number of bugs is going to grow, we probably
> want some infrastructure for this.

Yeah, there's the "bugs:" line in /proc/cpuinfo so it should be easy to
extend the X86_BUG_XXXX fun.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
