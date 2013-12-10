Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3LJVwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:52:18 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35681 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3LJVwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:52:17 -0500
MIME-Version: 1.0
In-Reply-To: <52A787D0.2070400@zytor.com>
References: <52A6D9B0.7040506@huawei.com>
	<CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com>
	<52A787D0.2070400@zytor.com>
Date: Tue, 10 Dec 2013 13:52:16 -0800
X-Google-Sender-Auth: TeY3bEfaPJdISlxeOUh7HTmWTnE
Message-ID: <CAE9FiQU8Y_thGxZamz0Uwt4FGXh7KJu7jGP8ED3dbjQuyq7vcQ@mail.gmail.com>
Subject: Re: [PATCH] mm,x86: fix span coverage in e820_all_mapped()
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linn Crosetto <linn@hp.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 1:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/10/2013 01:06 PM, Yinghai Lu wrote:
>> On Tue, Dec 10, 2013 at 1:06 AM, Xishi Qiu <qiuxishi@huawei.com> wrote:
>>> In the following case, e820_all_mapped() will return 1.
>>> A < start < B-1 and B < end < C, it means <start, end> spans two regions.
>>> <start, end>:           [start - end]
>>> e820 addr:          ...[A - B-1][B - C]...
>>
>> should be [start, end) right?
>> and
>> [A, B),[B, C)
>>
>
> What happens if it spans more than two regions?

[A, B), [B+1, C), [C+1, D) ?
start in [A, B), and end in [C+1, D).

old code:
first with [A, B), start set to B.
then with [B+1, C), start still keep as B.
then with [C+1, D), start still keep as B.
at last still return 0...aka not_all_mapped.

old code is still right.
