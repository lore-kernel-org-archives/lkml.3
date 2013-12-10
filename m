Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172Ab3LJWwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:52:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53624 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3LJWwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:52:32 -0500
Message-ID: <52A79B0D.4090303@zytor.com>
Date: Tue, 10 Dec 2013 14:51:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Xishi Qiu <qiuxishi@huawei.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm,x86: fix span coverage in e820_all_mapped()
References: <52A6D9B0.7040506@huawei.com>	<CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com>	<52A787D0.2070400@zytor.com> <CAE9FiQU8Y_thGxZamz0Uwt4FGXh7KJu7jGP8ED3dbjQuyq7vcQ@mail.gmail.com>
In-Reply-To: <CAE9FiQU8Y_thGxZamz0Uwt4FGXh7KJu7jGP8ED3dbjQuyq7vcQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 01:52 PM, Yinghai Lu wrote:
>>
>> What happens if it spans more than two regions?
> 
> [A, B), [B+1, C), [C+1, D) ?
> start in [A, B), and end in [C+1, D).
> 
> old code:
> first with [A, B), start set to B.
> then with [B+1, C), start still keep as B.
> then with [C+1, D), start still keep as B.
> at last still return 0...aka not_all_mapped.
> 
> old code is still right.
> 

Why not_all_mapped?

	-hpa

