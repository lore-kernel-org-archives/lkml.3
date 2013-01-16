Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3APRiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:38:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54265 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab3APRit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:38:49 -0500
Message-ID: <50F6E582.60905@zytor.com>
Date: Wed, 16 Jan 2013 09:38:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v7u1 00/31] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1301151214480.4978@kaball.uk.xensource.com> <CAE9FiQV1uxeHDVMcgNij7qAta+r2A52Jqwzb32Y1qgM13jUOeQ@mail.gmail.com> <CAE9FiQVhk4jc5WaOC5b+dn6Jo1w7s01MUBL16P43tNxav4kJzA@mail.gmail.com> <alpine.DEB.2.02.1301161048120.4978@kaball.uk.xensource.com> <CAE9FiQUYi_Bp2DW-G3Ht=Xz1rk+xks+NZe+-nAmvh4xR4dxVwA@mail.gmail.com>
In-Reply-To: <CAE9FiQUYi_Bp2DW-G3Ht=Xz1rk+xks+NZe+-nAmvh4xR4dxVwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 09:31 AM, Yinghai Lu wrote:
>
> rom af4f3bc044d1556f89bd488c7ea75e2a162bb273 Mon Sep 17 00:00:00 2001
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Mon, 14 Jan 2013 21:11:05 -0800
> Subject: [PATCH] x86, mm: Fix page table early allocation offset checking
>
> During debugging loading kernel above 4G, found that one page is not used
> in pre-allocated BRK area for early page allocation.
>
> pgt_buf_top is address that can not be used, so should check if that new
> end is above that top, otherwise last page will not be used.
>

The first sentence here doesn't parse, and this description doesn't give 
any hint to anyone who is researching this code in say, five years, what 
problems this caused.

I can't really figure it out, either; from looking at the thread and the 
patch I'm assuming the problem is somehow that the code failed to use 
the last page in the brk buffer, which somehow lead to a Xen boot 
failure... but the bits from here to there are totally unclear.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

