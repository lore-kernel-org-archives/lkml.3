Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3GOSKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:10:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43374 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab3GOSKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:10:06 -0400
Message-ID: <51E43ACD.9080307@zytor.com>
Date: Mon, 15 Jul 2013 11:09:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pageexec@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86: Make sure IDT is page aligned
References: <20130712225017.GA5366@www.outflux.net> <tip-c0b3450f101523a49823fa93d155f1d258e5ac6f@git.kernel.org> <CAE9FiQXvfopU1SYs3OFQk8rXVgq-Hbhw6gB49u5H4O70Tx12+A@mail.gmail.com>
In-Reply-To: <CAE9FiQXvfopU1SYs3OFQk8rXVgq-Hbhw6gB49u5H4O70Tx12+A@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2013 02:34 PM, Yinghai Lu wrote:
> 
> can we use put all idt_table related in to __bss.aligned section ...?
> 
> like
> gate_desc idt_table[NR_VECTORS] __page_aligned_bss;
> 

I think this is the best solution all around... it not only solves the
initializer problem but also reduces the size of data.

A long, long time ago in a galaxy far, far away I believe the IDT got
set up before we cleared bss, but that is no longer the case as we now
clear bss very, very early (on 32 bits before paging is even enabled.)

Still, it would seem that the minimal solution, if we need something for
3.11/stable, is to simply fix the alignment statement in head_64.S
(optionally move to .bss..page_aligned) and then do the proper cleanup
for 3.12.  If you could prepare a patch for the former (please include
the descriptions we discussed over IRC) and a patchset for the latter it
would be good.

Thanks,

	-hpa


