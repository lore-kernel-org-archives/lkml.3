Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab3LKD5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:57:33 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:34400 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3LKD5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:57:30 -0500
Message-ID: <52A7E223.9030605@huawei.com>
Date: Wed, 11 Dec 2013 11:55:15 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm,x86: fix span coverage in e820_all_mapped()
References: <52A6D9B0.7040506@huawei.com> <CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com> <52A7C16A.9040106@huawei.com> <52A7D415.6010908@zytor.com>
In-Reply-To: <52A7D415.6010908@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/11 10:55, H. Peter Anvin wrote:

> On 12/10/2013 05:35 PM, Xishi Qiu wrote:
>>
>> In this case, old code is right, but I discuss in another one that
>> you wrote above.
>>
> 
> So is there a problem or not?  I have lost track...
> 

I think there is a problem.
e.g.
[start, end)=[8, 12), and [A, B)=[0, 10), [B, C)=[10,20),
then e820_all_mapped() will return 1, it spans two regions.

Thanks,
Xishi Qiu

> 	-hpa
> 
> 
> 
> 



