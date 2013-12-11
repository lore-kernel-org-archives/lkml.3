Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab3LKBoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:44:25 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:63726 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3LKBoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:44:24 -0500
Message-ID: <52A7C2F8.4090207@huawei.com>
Date: Wed, 11 Dec 2013 09:42:16 +0800
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
References: <52A6D9B0.7040506@huawei.com> <CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com> <52A787D0.2070400@zytor.com> <CAE9FiQU8Y_thGxZamz0Uwt4FGXh7KJu7jGP8ED3dbjQuyq7vcQ@mail.gmail.com> <52A79B0D.4090303@zytor.com> <CAE9FiQVf+vAbW1v_VL5XSseQg06S6AX8RrE4vvJwPbLOeRcr=A@mail.gmail.com> <b2e6fc81-a956-46f7-9a44-a707064c24a2@email.android.com>
In-Reply-To: <b2e6fc81-a956-46f7-9a44-a707064c24a2@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/11 9:06, H. Peter Anvin wrote:

> Ok, the issue I thought we were discussing was actually [A,B) [B,C) [C,D) ...
> 

Hi Peter,

Yes, in this case the function will return 1.

Thanks,
Xishi Qiu

> Yinghai Lu <yinghai@kernel.org> wrote:
>> On Tue, Dec 10, 2013 at 2:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 12/10/2013 01:52 PM, Yinghai Lu wrote:
>>>>>
>>>>> What happens if it spans more than two regions?
>>>>
>>>> [A, B), [B+1, C), [C+1, D) ?
>>>> start in [A, B), and end in [C+1, D).
>>>>
>>>> old code:
>>>> first with [A, B), start set to B.
>>>> then with [B+1, C), start still keep as B.
>>>> then with [C+1, D), start still keep as B.
>>>> at last still return 0...aka not_all_mapped.
>>>>
>>>> old code is still right.
>>>>
>>>
>>> Why not_all_mapped?
>>
>> [B, B+1), and [C, C+1) are not there.
> 



