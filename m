Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935648Ab3BOKSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:18:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:42093 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3BOKSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:18:30 -0500
Date: Fri, 15 Feb 2013 11:18:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Sander <tim@krieglstein.org>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        gregkh@linuxfoundation.org
Subject: Re: [PATHC] 3.6 spinlock fix
In-Reply-To: <3258732.q5XBfts1EM@dabox>
Message-ID: <alpine.LFD.2.02.1302151117170.22263@ionos>
References: <6003615.pRQnIgKCSn@dabox> <alpine.LFD.2.02.1302142334120.22263@ionos> <CAP=VYLo2zxJWy3s6AmZc+Hh6wXh67HMp+mM0nEkN6M_OpKJSug@mail.gmail.com> <3258732.q5XBfts1EM@dabox>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013, Tim Sander wrote:
> > On Thu, Feb 14, 2013 at 5:35 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Thu, 14 Feb 2013, Tim Sander wrote:
> > >> > That's true, but w/o seing the OOM output I can't tell what's
> > >> > exhausting the memory.
> > >> 
> > >> When fuzzing the serial port one probably should switch of sysreq. It
> > >> seems
> > >> as if there is a break send somehow and then it selects the OOM option.
> > >> So when switching of MAGIC_SYSRQ the OOMs are gone. So its a non issue.
> > > 
> > > Amazing that you get the break+oom combo out of that fuzzer!
> That fuzzer is running at 57600Hz while the serial port of the fuzzed device is
> running twice that rate. The break condition seems to be easy hit by the fuzzer
>  i've sent in a previous mail. 
> > Doing a basic "git whatchanged" and searching for "trinity" is rather
> > impressive, regardless of the kernel version and/or where "rogue states"
> > may currently be at with their "program"....   Kudos to davej for that.
> Mh, but thats not trinity! Havn't tried that but well fuzzing at a different 
> serial rate than the receiver might be a good idea even if it sounds pretty stupid.
> 
> Attached is the patch for the 3.6.9-rt kernel (but i think this should also apply 
> to the "normal" 3.6 i guess).  But as Greg already took care of this patch i guess 
> that only for convinience. Also it seems as if the patch sent to Greg is missing the
> #include <linux/kdb.h>?

Errm, no. The in_kdb_printk() is an RT specific issue, so I left it
out for the mainline fix.

Thanks,

	tglx
