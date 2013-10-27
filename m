Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3J0NQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:16:55 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:54369 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3J0NQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:16:54 -0400
MIME-Version: 1.0
In-Reply-To: <20131027125036.GJ17447@blackmetal.musicnaut.iki.fi>
References: <20131024200730.GB17447@blackmetal.musicnaut.iki.fi>
	<20131026143617.GA14034@mudshark.cambridge.arm.com>
	<20131027195115.208f40f3@tom-ThinkPad-T410>
	<20131027125036.GJ17447@blackmetal.musicnaut.iki.fi>
Date: Sun, 27 Oct 2013 21:16:53 +0800
Message-ID: <CACVXFVP2B3=82m_+DfA_oAEW86c=oxQ52G+yj5ncTU1DzP26Bw@mail.gmail.com>
Subject: Re: ARM/kirkwood: v3.12-rc6: kernel BUG at mm/util.c:390!
From: Ming Lei <tom.leiming@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Simon Baatz <gmbnomis@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 8:50 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
>
> On ARM v3.9 or older kernels do not trigger this BUG, at seems it only
> started to appear with the following commit (bisected):
>
> commit 1bc39742aab09248169ef9d3727c9def3528b3f3
> Author: Simon Baatz <gmbnomis@gmail.com>
> Date:   Mon Jun 10 21:10:12 2013 +0100
>
>     ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page

The above commit only starts to implement the helper on ARM,
but according to Documentation/cachetlb.txt, looks caller of
flush_kernel_dcache_page() should make sure the passed
'page' is a user space page.

Thanks,
-- 
Ming Lei
