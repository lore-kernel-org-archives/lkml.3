Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3LKBHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:07:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54858 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3LKBH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:07:26 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQVf+vAbW1v_VL5XSseQg06S6AX8RrE4vvJwPbLOeRcr=A@mail.gmail.com>
References: <52A6D9B0.7040506@huawei.com> <CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com> <52A787D0.2070400@zytor.com> <CAE9FiQU8Y_thGxZamz0Uwt4FGXh7KJu7jGP8ED3dbjQuyq7vcQ@mail.gmail.com> <52A79B0D.4090303@zytor.com> <CAE9FiQVf+vAbW1v_VL5XSseQg06S6AX8RrE4vvJwPbLOeRcr=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mm,x86: fix span coverage in e820_all_mapped()
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 10 Dec 2013 17:06:36 -0800
To: Yinghai Lu <yinghai@kernel.org>
CC: Xishi Qiu <qiuxishi@huawei.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>
Message-ID: <b2e6fc81-a956-46f7-9a44-a707064c24a2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, the issue I thought we were discussing was actually [A,B) [B,C) [C,D) ...

Yinghai Lu <yinghai@kernel.org> wrote:
>On Tue, Dec 10, 2013 at 2:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/10/2013 01:52 PM, Yinghai Lu wrote:
>>>>
>>>> What happens if it spans more than two regions?
>>>
>>> [A, B), [B+1, C), [C+1, D) ?
>>> start in [A, B), and end in [C+1, D).
>>>
>>> old code:
>>> first with [A, B), start set to B.
>>> then with [B+1, C), start still keep as B.
>>> then with [C+1, D), start still keep as B.
>>> at last still return 0...aka not_all_mapped.
>>>
>>> old code is still right.
>>>
>>
>> Why not_all_mapped?
>
>[B, B+1), and [C, C+1) are not there.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
