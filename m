Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaCaQXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:23:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39103 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbaCaQXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:23:52 -0400
Date: Mon, 31 Mar 2014 18:23:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Jacob Shin <jacob.shin@amd.com>, Jeff Layton <jlayton@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: microcode: report if CPU has up-to-date
 microcode
Message-ID: <20140331162340.GB16144@pd.tnic>
References: <1396188574-2067-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1396188574-2067-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 04:09:32PM +0200, Denys Vlasenko wrote:
> Before this change, successful microcode uploads clearly
> indicate that it was done:
> 
> microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1a
> microcode: CPU1 updated to revision 0x29, date = 2013-06-12
> 
> whereas if microcode was not uploaded, it is not clear why:
> 
> microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x29
> (nothing more)
> 
> So, what was it? No microcode file? No microcode for this sig/pf?
> CPU already has microcode with this (or newer) revision?
> 
> In practice, it means that I need to ask people to provide me
> with more information ("do you have microcode package installed?
> which version is it?" etc).

Well, hmm.

First of all, microcode version is in /proc/cpuinfo. Issuing the reason
why microcode wasn't loaded in dmesg and then the dmesg ring buffer
wraps around doesn't make a lot of sense, in my not really too humble
opinion.

So, for debugging cases, you're probably going to have to ask for
/proc/cpuinfo anyway and then check the CPU vendor's site for newer
microcode packages and compare, instead of relying that dmesg still
contains that info.

Besides, experience shows that dmesg messages like those tend to spook
users and we don't want that :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
