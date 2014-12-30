Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaL3HQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 02:16:34 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48101 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaL3HQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 02:16:33 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0d-54a2514e0dd2
Message-id: <54A25135.5030103@samsung.com>
Date: Tue, 30 Dec 2014 08:16:05 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kstrdup optimization
References: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
 <87egrhws89.fsf@tassilo.jf.intel.com>
In-reply-to: <87egrhws89.fsf@tassilo.jf.intel.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t/xa7p+gYtCDPpemFscufad3eLyrjls
	FvfW/Ge1WHvkLrsDi8f8nR8ZPTZ9msTu0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBlfm6+z
	FnxirZjz5hNLA+Mdli5GTg4JAROJrY8vM0PYYhIX7q1n62Lk4hASWMoosenfWbAiIYFPjBLH
	piqB2LwCWhInNn9k6mLk4GARUJU4+FQUJMwmoCnxd/NNNhBbVCBC4sOqr2wQ5YISPybfYwEp
	FxFQkTh+ig8kzCyQLPH8xzp2EFtYwFBixe9lbBCbsiWe3jgIZnMKGEms+v2YFaSVWUBP4v5F
	LYhWeYnNa94yT2AUmIVkwSyEqllIqhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAna
	LzsYFx+zOsQowMGoxMO74f3CECHWxLLiytxDjBIczEoivI0Gi0KEeFMSK6tSi/Lji0pzUosP
	MTJxcEo1MLp9UxKdKV91uliijzu++VKj7+qjf1x5VM7kfd6zXLjPtW6616R5VnNu8faJdt1x
	CvH8sfCpRPaCpRUOzlcX588zu/W31D1559HMXuMgxY/qLU334xuT3oTO89zb+DMs+FP8pTLu
	Wo/48mfrJ1V7HuC4v/GgAfufpwbvnG8VM36o498o29DQpMRSnJFoqMVcVJwIAPPsvmo4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2014 07:45 AM, Andi Kleen wrote:
> Andrzej Hajda <a.hajda@samsung.com> writes:
>
>> kstrdup if often used to duplicate strings where neither source neither
>> destination will be ever modified. In such case we can just reuse the source
>> instead of duplicating it. The problem is that we must be sure that
>> the source is non-modifiable and its life-time is long enough.
> What happens if someone is to kfree() these strings?
>
> -Andi
>
kstrdup_const must be accompanied by kfree_const, I did not mention it
in cover letter
but it is described in the 1st patch commit message.
Simpler alternative (but I am not sure if better) would be to add
similar check
(ie. if pointer is in .rodata) to kfree itself.

Regards
Andrzej
