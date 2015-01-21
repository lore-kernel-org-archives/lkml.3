Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbbAUGrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:47:04 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:51489 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbbAUGrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:47:02 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1501201407050.10817@pobox.suse.cz>
References: <1420304509-13072-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<alpine.LNX.2.00.1501201407050.10817@pobox.suse.cz>
Date: Wed, 21 Jan 2015 14:47:01 +0800
Message-ID: <CAMk6uBk8gPAsKKqZPC=9dxRkiXm7893SwK1fd6J4Bc+iVkG+uA@mail.gmail.com>
Subject: Re: [PATCH] blackfin: mach-common: ints-priority: Remove unused function
From: Steven Miao <realmz6@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Randy Dunlap <rdunlap@infradead.org>, Christoph Lameter <cl@linux.com>,
        Masanari Iida <standby24x7@gmail.com>,
        bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 9:07 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 3 Jan 2015, Rickard Strandqvist wrote:
>
>> Remove the function bfin_sec_resume() that is not used anywhere.
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> This doesn't seem to be present in linux-next as of today, so I am picking
> it up.
It seems it's still in today's linux-next?
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/blackfin/mach-common/ints-priority.c#n432
>
>> ---
>>  arch/blackfin/mach-common/ints-priority.c |    8 --------
>>  1 file changed, 8 deletions(-)
>>
>> diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
>> index dd2af74..7236bdf 100644
>> --- a/arch/blackfin/mach-common/ints-priority.c
>> +++ b/arch/blackfin/mach-common/ints-priority.c
>> @@ -429,14 +429,6 @@ static void init_software_driven_irq(void)
>>       bfin_sec_enable_ssi(37);
>>  }
>>
>> -void bfin_sec_resume(void)
>> -{
>> -     bfin_write_SEC_SCI(0, SEC_CCTL, SEC_CCTL_RESET);
>> -     udelay(100);
>> -     bfin_write_SEC_GCTL(SEC_GCTL_EN);
>> -     bfin_write_SEC_SCI(0, SEC_CCTL, SEC_CCTL_EN | SEC_CCTL_NMI_EN);
>> -}
>> -
>>  void handle_sec_sfi_fault(uint32_t gstat)
>>  {
>>
>> --
>> 1.7.10.4
>>
>
> --
> Jiri Kosina
> SUSE Labs
