Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab3LJVbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:31:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52565 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab3LJVbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:31:40 -0500
Message-ID: <52A787D0.2070400@zytor.com>
Date: Tue, 10 Dec 2013 13:29:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Xishi Qiu <qiuxishi@huawei.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm,x86: fix span coverage in e820_all_mapped()
References: <52A6D9B0.7040506@huawei.com> <CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com>
In-Reply-To: <CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 01:06 PM, Yinghai Lu wrote:
> On Tue, Dec 10, 2013 at 1:06 AM, Xishi Qiu <qiuxishi@huawei.com> wrote:
>> In the following case, e820_all_mapped() will return 1.
>> A < start < B-1 and B < end < C, it means <start, end> spans two regions.
>> <start, end>:           [start - end]
>> e820 addr:          ...[A - B-1][B - C]...
> 
> should be [start, end) right?
> and
> [A, B),[B, C)
> 

What happens if it spans more than two regions?

	-hpa


