Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3HLXrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 19:47:08 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:42564 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3HLXrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 19:47:06 -0400
MIME-Version: 1.0
In-Reply-To: <52090CF2.3040505@sr71.net>
References: <520578D0.7020607@intel.com>
	<CAE9FiQUuPmZfhsHvmsS+_O_VOWMA_OBAexGyRF3eZR1_D3EehA@mail.gmail.com>
	<52059508.3090405@sr71.net>
	<CAE9FiQVvo+saJFpx=6A8O7GOns0cR302_GBe4A0a10a4Z0mZyw@mail.gmail.com>
	<CAE9FiQWn5+XH7cjUjRJNuB747u2-aq3ZpXoPwyZEFYALCxZ30Q@mail.gmail.com>
	<52090CF2.3040505@sr71.net>
Date: Mon, 12 Aug 2013 16:47:04 -0700
X-Google-Sender-Auth: ZyGVmdTMDGPZ0CoezcGE-mWyrz0
Message-ID: <CAE9FiQVbGrXLEWVNugJUa=YAA8mHyTM32Ow5kUU7cYBvMpk5gA@mail.gmail.com>
Subject: Re: x86: early boot crash: "alloc_low_page: ran out of memory" (bisected)
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 9:27 AM, Dave Hansen <dave@sr71.net> wrote:
> On 08/09/2013 07:21 PM, Yinghai Lu wrote:
>> -/* need 4 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
>> -#define INIT_PGT_BUF_SIZE    (5 * PAGE_SIZE)
>> +/* need 4 4k for initial PMD_SIZE,  3 4k for 0-ISA_END_ADDRESS */
>> +#define INIT_PGT_BUF_SIZE    (7 * PAGE_SIZE)
>>  RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);
>>  void  __init early_alloc_pgt_buf(void)
>
> That patch allows me to boot again.  I've also attached a boot with the
> debug options that you asked for.
>
> I'm really curious to see the full changelog for why this patch helps
> any why it's only triggered for large memory sizes. :)

Thanks, please check changelog at

https://patchwork.kernel.org/patch/2843321/

Yinghai
