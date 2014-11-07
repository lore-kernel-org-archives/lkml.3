Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaKGRtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:49:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56433 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaKGRtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:49:22 -0500
Date: Fri, 7 Nov 2014 18:49:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org,
        H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 5/8] x86, microcode, intel: don't check extsig entry
 checksum
Message-ID: <20141107174917.GB5180@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-6-git-send-email-hmh@hmh.eng.br>
 <20141030202550.GF11178@pd.tnic>
 <20141031171440.GA27028@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141031171440.GA27028@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 03:14:40PM -0200, Henrique de Moraes Holschuh wrote:
> > I don't know where you come up with this but the code you're removing
> > was added in 2013:
> > 
> > 	e666dfa273db ("x86/microcode_intel_lib.c: Early update ucode on Intel's CPU")
> 
> Was it?  As far as I know, it is "heavily based" (i.e. copied and adapted)
> on code from the regular microcode driver, and not rewritten from scrach.
> 
> If I am correct, this really is code from 2003, changed by 11 years worth of
> file renaming, file splits, and refactoring.
> 
> It took me about 30 minutes to track the origin of this code in the regular
> Intel microcode driver.  As far as I can tell, it was added to version 1.12
> of the original driver, somewhere between v2.6.0-test7 and v2.6.0-test8.
> 
> The Intel engineers credited for the original change are: Nitin Kamble
> <nitin.a.kamble@intel.com> and Jun Nakajima <jun.nakajima@intel.com>.
> (information from the changelog at the top of the driver source).
> 
> You can see one of the earliest versions of the code here:
> https://git.kernel.org/cgit/linux/kernel/git/history/history.git/tree/arch/i386/kernel/microcode.c?id=v2.6.0-test8
> 
> The extended table checksum gets calculated around line 323.  The possibly
> problematic logic is in line 341 and 345, and matches what the modern driver
> does.

Ok so e666dfa273db only adds code so I assumed it was new.

> I am not so sure.  Besides, it is entirely possible that the Intel SDM got
> updated in that area after the september 2003 code drop.  This is very hard
> to verify outside of Intel.   Or, maybe, the issue was detected internally
> at Intel, and it was decided that the issue should be shelved until the day
> extended microcode tables are actually required (which didn't happen yet).

Yeah, I wouldn't want to remove code from the loader without Intel
people saying something first.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
