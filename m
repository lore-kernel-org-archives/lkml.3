Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab3A2CTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:19:10 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:44474 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3A2CTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:19:07 -0500
MIME-Version: 1.0
In-Reply-To: <51072FEF.50000@zytor.com>
References: <1358868049-19884-1-git-send-email-trenn@suse.de>
	<CAE9FiQWJqWQJhoJb2dBn=iAsKjxuf3MJro-jz+6k+WNZor8-xQ@mail.gmail.com>
	<CAE9FiQWXcwagEb0jdFfdHvNcByNxtaLbvvoRC-jAppQmiGS22w@mail.gmail.com>
	<6950516.1uefDuthAH@hammer82.arch.suse.de>
	<510721C6.6080705@zytor.com>
	<CAE9FiQWDcFR+6L-GiR6rk60TC0zH=xewyH_h1Rx_QB+8PTiU3Q@mail.gmail.com>
	<51072FEF.50000@zytor.com>
Date: Mon, 28 Jan 2013 18:19:07 -0800
X-Google-Sender-Auth: tZttUt2830K-Tq0xbqW7_wEQHPk
Message-ID: <CAE9FiQVG4ShGKSdjzYhQaXNNhS=MVNJg=QqG1yW-mAUscErXMA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump usage
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 6:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/28/2013 06:10 PM, Yinghai Lu wrote:
>>
>>
>> kexec-tools will change that to E820_KDUMP_RESERVED (or other good name).
>>
>> We only need to update kernel to get old max_pfn by
>> checking E820_KDUMP_RESERVED.
>>
>
> OK, I have asked this before, but I still have not gotten any acceptable
> answer:
>
> Why do we still have max_*_pfn at all?  Shouldn't it all be based on
> memblocks by now?

saved_max_pfn is used for kdump:
drivers/char/mem.c::read_oldmem will stop there.
...
        while (count) {
                pfn = *ppos / PAGE_SIZE;
                if (pfn > saved_max_pfn)
                        return read;
...
