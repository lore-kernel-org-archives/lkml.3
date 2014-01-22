Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbaAVNFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:05:05 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:25324 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbaAVNFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:05:02 -0500
Message-ID: <52DFC1BA.8030001@huawei.com>
Date: Wed, 22 Jan 2014 21:03:54 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Vaibhav Bedia <vaibhav.bedia@gmail.com>
CC: <kexec@lists.infradead.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Geng Hui <hui.geng@huawei.com>,
        <linux-mm@kvack.org>, Eric Biederman <ebiederm@xmission.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] ARM: kexec: copying code to ioremapped area
References: <1390389916-8711-1-git-send-email-wangnan0@huawei.com>	<1390389916-8711-3-git-send-email-wangnan0@huawei.com> <CANacCWz2DdLvns9htszpwWnASrYGXQt+tHMsw4aBbjoyw-DmeQ@mail.gmail.com>
In-Reply-To: <CANacCWz2DdLvns9htszpwWnASrYGXQt+tHMsw4aBbjoyw-DmeQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/22 20:56, Vaibhav Bedia wrote:
> On Wed, Jan 22, 2014 at 6:25 AM, Wang Nan <wangnan0@huawei.com <mailto:wangnan0@huawei.com>> wrote:
> 
>     ARM's kdump is actually corrupted (at least for omap4460), mainly because of
>     cache problem: flush_icache_range can't reliably ensure the copied data
>     correctly goes into RAM. After mmu turned off and jump to the trampoline, kexec
>     always failed due to random undef instructions.
> 
>     This patch use ioremap to make sure the destnation of all memcpy() is
>     uncachable memory, including copying of target kernel and trampoline.
> 
> 
> AFAIK ioremap on RAM in forbidden in ARM and device memory that ioremap()
> ends up creating is not meant for executable code.
> 
> Doesn't this trigger the WARN_ON() in _arm_ioremap_pfn_caller)?

This patch is depend on the previous one:

ARM: Premit ioremap() to map reserved pages

However, Russell is opposed to it.


