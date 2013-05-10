Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3EJJ1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:27:15 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:55371 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3EJJ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <518CB758.4000101@cn.fujitsu.com>
References: <518CB758.4000101@cn.fujitsu.com>
Date: Fri, 10 May 2013 02:27:13 -0700
X-Google-Sender-Auth: 8pYuDEYpuEyPqPPxi-i0Op_LBhE
Message-ID: <CAE9FiQVpbDJT2Ma6MHkB5aF9PUuGCia_QaLc_LjYCLJb4nKebg@mail.gmail.com>
Subject: Re: [PATCH] x86: mm: Remove unnecessary assignment for max_pfn_mapped:q
From: Yinghai Lu <yinghai@kernel.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 2:01 AM, Zhang Yanfei
<zhangyanfei@cn.fujitsu.com> wrote:
> init_memory_mapping will set max_pfn_mapped:
> int_memory_mapping
>   --> add_pfn_range_mapped
>     --> max_pfn_mapped = max(max_pfn_mapped, end_pfn)
>
> In init_mem_mapping, before we set max_pfn_mapped to 0, we
> have already called init_memory_mapping to setup pagetable
> for [0, ISA_END_ADDRESS], and that sets max_pfn_mapped. So
> the assignment to 0 is not necessary, remove it.

NAK.

for 32bit or Xen, max_pfn_mapped is set way before in head_32.S and
xen-enlighen.

Yinghai
