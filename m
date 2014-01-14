Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaANQUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:20:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52149 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbaANQUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:20:05 -0500
Message-ID: <52D5637C.9000609@zytor.com>
Date: Tue, 14 Jan 2014 08:19:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip
 tree
References: <20140114155331.88d170d3c991b9465c23a537@canb.auug.org.au>	<20140114125153.GY7572@laptop.programming.kicks-ass.net> <CAMuHMdUPJ7pu5J6om+j=Tm8xDXhXU3sD4k7ZP6b4Xu-tF+gK2w@mail.gmail.com>
In-Reply-To: <CAMuHMdUPJ7pu5J6om+j=Tm8xDXhXU3sD4k7ZP6b4Xu-tF+gK2w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 05:17 AM, Geert Uytterhoeven wrote:
>>
>> This seems terribly broken, the *futex_value*() ops should not need
>> that; they are supposed to access userspace without any of that.
> 
> Why don't they need set_fs(USER_DS)?
> 
> Gr{oetje,eeting}s,
> 
>                         Geert

Because USER_DS is the normal operating state?  It would appear m68k is
the only(?) arch that calls initcalls with get_fs() == KERNEL_DS...

	-hpa


