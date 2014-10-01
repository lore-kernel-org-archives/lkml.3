Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaJAQR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:17:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41590 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaJAQRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:17:54 -0400
Message-ID: <542C2916.7010500@zytor.com>
Date: Wed, 01 Oct 2014 09:17:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Sebastian Lackner <sebastian@fds-team.de>, X86 ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Anish Bhatt <anish@chelsio.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
References: <cover.1412138935.git.luto@amacapital.net> <0e906bdeba3660c9766248d3d7229e78a423ca5b.1412138935.git.luto@amacapital.net> <542C1C28.9050408@zytor.com> <542C1D2E.9050005@zytor.com> <CALCETrU2_tS-tmWAkW0vscOqQ89JrRrnjCA3P1aiZM-Xvj_oMA@mail.gmail.com> <CALCETrXWL7ze+7Y7ZHT8j8eZqJb_uRsA1PZsuzSu2cJV0tFgog@mail.gmail.com>
In-Reply-To: <CALCETrXWL7ze+7Y7ZHT8j8eZqJb_uRsA1PZsuzSu2cJV0tFgog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 09:04 AM, Andy Lutomirski wrote:
> 
> Agner Fog's tables for Sandy Bridge have 9 uops for popf and
> reciprocal throughput 18.  sti isn't listed for Sandy Bridge or
> anything similar, but cld is 3 uops with reciprocal throughput 4.
> Also, popf accesses rsp, and the sysenter code is very heavy on stack
> manipulation.
> 

It does a stack operation.  Newer CPUs optimize stack accesses pretty
heavily.  That doesn't mean back-to-back push/pop are all that
optimized, I wonder if it would help separating them.  popf is unlikely
to ever be all that fast.

	-hpa

