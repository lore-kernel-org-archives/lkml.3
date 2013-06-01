Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab3FALCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 07:02:39 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40878 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab3FALC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 07:02:29 -0400
Date: Sat, 1 Jun 2013 20:01:59 +0900 (PWT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Russ Anderson <rja@sgi.com>,
        joeyli <jlee@suse.com>, Matt Fleming <matt@console-pimps.org>,
        matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
In-Reply-To: <20130531143425.GA5850@srcf.ucam.org>
Message-ID: <alpine.LFD.2.03.1306011956350.9068@pixel.linux-foundation.org>
References: <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz> <20130529224645.GA16582@sgi.com> <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz> <1369880172.17397.11.camel@linux-s257.site> <20130530221737.GA11105@sgi.com> <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com> <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz> <20130531123015.GC17843@nazgul.tnic> <20130531124356.GA8212@gmail.com> <20130531143425.GA5850@srcf.ucam.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 May 2013, Matthew Garrett wrote:
> 
> I agree that a revert is probably the right thing to do here, but the 
> original patch was there to permit a more accurate calculation of the 
> amount of nvram in use, not to provide additional debug information. 
> Reverting it is going to differently break a different set of systems

So "differently break" doesn't matter, if it's old breakage, and people 
thus don't really expect it to work. We need to fix bugs without *new* 
breakage, and quite frankly, I have been distressed by hearing the EFI 
"specifications" mentioned so many times in this thread.

Firmware specs are pure and utter garbage. They are irrelevant. Firmware 
is buggy, and will always be buggy. The "spec" doesn't matter. We should 
use firmware for loading the kernel, and as little else as humanly 
possible.

I'm very disappointed in how the EFI code doesn't seem to understand that. 
There's tons of these stupid EFI variable crap that simply shouldn't 
matter. Quite frankly, we'd be better off ignoring as much of it by 
default as at all possible. Exactly because the more of an EFI interface 
we have, the more we open us up to th einevitable firmware bugs.

Anyway, I'm traveling with absolutely horrendous internet access, so can 
somebody please send a description of the revert with the relevant 
information, because I literally have a hard time extracting it all from 
this thread because my email access is so slow and flaky... Make it easy 
for me to do the revert with a good explanation message, please,

               Linus
