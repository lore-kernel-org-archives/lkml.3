Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaIOHR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:17:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12651 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaIOHRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:17:54 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-f6-5416929f2d55
Message-id: <5416910F.9020106@samsung.com>
Date: Mon, 15 Sep 2014 11:11:11 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.0
MIME-version: 1.0
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC/PATCH v2 04/10] mm: slub: introduce virt_to_obj function.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-5-git-send-email-a.ryabinin@samsung.com>
 <alpine.DEB.2.11.1409101116160.1654@gentwo.org>
 <CAPAsAGxuoXEM2AXRV_at0=xiLOmaZe+QY-45KeA7ZvvHzhOqMg@mail.gmail.com>
In-reply-to: <CAPAsAGxuoXEM2AXRV_at0=xiLOmaZe+QY-45KeA7ZvvHzhOqMg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t/xq7rzJ4mFGOyZrWfxe+9MVos569ew
	WRy59p3d4vq3N4wWn14+YLR4/vAhu8WEh23sFtM2ilus7G5ms9j+7C2TxcrOB6wWl3fNYbO4
	t+Y/q0Xb539AYslGJovjW7cwWyw+cpvZ4t2zycwWV1cdZLf4seExq4OIx/ydHxk9ds66y+6x
	YFOpx+I9L5k8Nq3qZPPY9GkSu0fX2ytMHidm/GbxeHJlOpPHx6e3WDw+b5LzONHyhTWAJ4rL
	JiU1J7MstUjfLoEr493becwFr1kqmideYW9g/MLcxcjJISFgIrHn/HZGCFtM4sK99WxdjFwc
	QgJLGSWObPzODpIQEmhmkjjxzBLE5hXQkli5fTdYA4uAqsSJD1tYQGw2AT2Jf7O2s4HYogIR
	ElP2L2WFqBeU+DH5HliNiICfxNfeFiaQBcwC61glPi++CZYQFvCW2P9rDdTmHUwSP6evB9vM
	KRAsMWXiKzCbWUBdYtK8RcwQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLU0uKE5KzzXS
	K07MLS7NS9dLzs/dxAiJ1q87GJceszrEKMDBqMTDe+GLcIgQa2JZcWXuIUYJDmYlEd5Ad7EQ
	Id6UxMqq1KL8+KLSnNTiQ4xMHJxSDYx7w0VupRlUrJb8Gq17622eWNmTdS8Pi+6t3CG7S1g0
	JH7B85LcFnudBZcfsqw2qe7f/nmJneDRt55z/F/e/Panz1T+pRb3jPddzWuNFsR6ynuv9v/9
	6MqhViOVlBPLr/WuPrjihdRD/c7IR+23Y9hXsk+u4j3YWr0iIKxlX7SHd432rg1CHsZKLMUZ
	iYZazEXFiQCAX6nrtAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 12:32 AM, Andrey Ryabinin wrote:
> 2014-09-10 20:16 GMT+04:00 Christoph Lameter <cl@linux.com>:
>> On Wed, 10 Sep 2014, Andrey Ryabinin wrote:
>>
>>> virt_to_obj takes kmem_cache address, address of slab page,
>>> address x pointing somewhere inside slab object,
>>> and returns address of the begging of object.
>>
>> This function is SLUB specific. Does it really need to be in slab.h?
>>
> 
> Oh, yes this should be in slub.c
> 

I forgot that include/linux/slub_def.h exists. Perhaps it would be better to move
virt_to_obj into slub_def.h to avoid ugly #ifdef CONFIG_KASAN in slub.c

