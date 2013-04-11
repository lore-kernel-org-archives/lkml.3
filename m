Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936381Ab3DKPnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:43:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34712 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934954Ab3DKPnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:43:07 -0400
Date: Thu, 11 Apr 2013 11:42:02 -0400
Subject: Re: [tip:x86/urgent] x86, mm: Patch out arch_flush_lazy_mmu_mode()
 when running on bare metal
Message-ID: <lkvk8wgl00gj6ba39c8n7j68.1365694922569@email.android.com>
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, jwboyer@redhat.com, tglx@linutronix.de,
        bp@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3BFh9eD004592

I am sorry for top posting. Haven't figured out how to reply inline in the Android email client.

Boris, could you repost it please? If I recall correctly the only question on that patch was whether to put stable@vger.kernel.org on it and it was decided (by Greg) that was OK.

It is not an urgent patch though as it is only exposed with debug kernels.

Boris Ostrovsky <boris.ostrovsky@oracle.com> wrote:

>On 04/10/2013 08:30 PM, tip-bot for Boris Ostrovsky wrote:
>> Commit-ID:  511ba86e1d386f671084b5d0e6f110bb30b8eeb2
>> Gitweb:     http://git.kernel.org/tip/511ba86e1d386f671084b5d0e6f110bb30b8eeb2
>> Author:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> AuthorDate: Sat, 23 Mar 2013 09:36:36 -0400
>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> CommitDate: Wed, 10 Apr 2013 11:25:10 -0700
>>
>> x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal
>>
>> Invoking arch_flush_lazy_mmu_mode() results in calls to
>> preempt_enable()/disable() which may have performance impact.
>>
>> Since lazy MMU is not used on bare metal we can patch away
>> arch_flush_lazy_mmu_mode() so that it is never called in such
>> environment.
>>
>> [ hpa: the previous patch "Fix vmalloc_fault oops during lazy MMU
>>    updates" may cause a minor performance regression on
>>    bare metal.  This patch resolves that performance regression.  It is
>>    somewhat unclear to me if this is a good -stable candidate. ]
>
>I think this
>
>    https://lkml.org/lkml/2013/2/26/420
>
>was also part of lazy mmu set of patches but is missing in the latest 
>batch of
>commits.
>
>-boris
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
