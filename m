Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaA1Pgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:36:44 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:35924 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbaA1Pgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:36:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
	<1390590670-25901-4-git-send-email-yinghai@kernel.org>
	<CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com>
Date: Tue, 28 Jan 2014 07:30:03 -0800
Message-ID: <CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
From: Kevin Hilman <khilman@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 12:02 AM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> On Fri, Jan 24, 2014 at 11:11 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> The new memblock_virt APIs are used to replaced old bootmem API.
>>
>> We need to allocate page below 4G for swiotlb.
>>
>> That should fix regression on Andrew's system that is using swiotlb.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
> This seems to have been merged by Linus tonight as ad6492b80f, and it
> had fallout on ARM systems (boot failures with no console output on
> all but 5 of my machine/config combos).
>
> Seems like it didn't have a chance to sit in -next, which is somewhat
> understandable given that it's considered a bugfix and it indeed fixed
> the bug it was meant to.
>
> i'm out of time to debug this tonight (I noticed the failures as I was
> heading to bed and figured I'd at least bisect them), so I wouldn't
> mind seeing a revert of the ARM side change of ad6492b80f until it's
> been sorted out so we keep bisectabilty intact for the rest of the
> kernel.

Like Olof, I noticed multiple boot failures on various ARM boards.
I've confirmed that reverting the arch/arm part of this patch makes
them all happily booting again.

Kevin
