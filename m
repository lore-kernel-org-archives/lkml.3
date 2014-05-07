Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaEGPmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:42:38 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:48281 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbaEGPmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:42:36 -0400
Date: Wed, 7 May 2014 17:42:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>, ak@linux.intel.com,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] x86, nmi: Add better NMI stats to /proc/interrupts
 and show handlers
Message-ID: <20140507154231.GB14926@gmail.com>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
 <1399476883-98970-6-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399476883-98970-6-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> The main reason for this patch is because I have a hard time knowing
> what NMI handlers are registered on the system when debugging NMI issues.
> 
> This info is provided in /proc/interrupts for interrupt handlers, so I
> added support for NMI stuff too.  As a bonus it provides stat breakdowns
> much like the interrupts.
> 
> The only ugly issue is how to label NMI subtypes using only 3 letters
> and still make it obvious it is part of the NMI.  Adding a /proc/nmi
> seemed overkill, so I choose to indent things by one space.  Sample
> output is below:
> 
> [root@dhcp71-248 ~]# cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   0:         29          0          0          0  IR-IO-APIC-edge      timer
> <snip>
> NMI:         20        774      10986       4227   Non-maskable interrupts
>  LOC:         21        775      10987       4228  Local     PMI, arch_bt
>  EXT:          0          0          0          0  External  plat
>  UNK:          0          0          0          0  Unknown
>  SWA:          0          0          0          0  Swallowed
> LOC:      30374      24749      20795      15095   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:         20        774      10986       4227   Performance monitoring interrupts
> <snip>

Looks pretty useful!

The lost vertical alignment of the counts is a problem though IMHO.

Thanks,

	Ingo
