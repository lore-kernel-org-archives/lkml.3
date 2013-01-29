Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3A2CKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:10:41 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:38334 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3A2CKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:10:38 -0500
MIME-Version: 1.0
In-Reply-To: <510721C6.6080705@zytor.com>
References: <1358868049-19884-1-git-send-email-trenn@suse.de>
	<CAE9FiQWJqWQJhoJb2dBn=iAsKjxuf3MJro-jz+6k+WNZor8-xQ@mail.gmail.com>
	<CAE9FiQWXcwagEb0jdFfdHvNcByNxtaLbvvoRC-jAppQmiGS22w@mail.gmail.com>
	<6950516.1uefDuthAH@hammer82.arch.suse.de>
	<510721C6.6080705@zytor.com>
Date: Mon, 28 Jan 2013 18:10:38 -0800
X-Google-Sender-Auth: R8275qA4XdeFNLXfWWvTNKhOhsE
Message-ID: <CAE9FiQWDcFR+6L-GiR6rk60TC0zH=xewyH_h1Rx_QB+8PTiU3Q@mail.gmail.com>
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

On Mon, Jan 28, 2013 at 5:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> So I guess the final patch should be:
>>    - Add a new e820 type:
>>         E820_KDUMP_RESERVED /* Originally usable memory where the crashed
>>                                                     kernel kernel resided in */
>>   - Use Yinghai's last posted patch, but instead of:
>> +                     e820_update_range(0, ULLONG_MAX, E820_RAM,
>> +                                       E820_RESERVED);
>> ...
>> +                     e820_remove_range(start_at, mem_size, E820_RESERVED, 0);
>> do:
>> +                     e820_update_range(0, ULLONG_MAX, E820_RAM,
>> +                                       E820_KDUMP_RESERVED);
>> ...
>> +                     e820_remove_range(start_at, mem_size, E820_KDUMP_RESERVED, 0);
>>
>>   - Come up with another memmap=kdump_reserve_ram memmap option name
>>     or however it should get named...
>>
>> If this proposal gets accepted, I can send a tested patch...
>>
>
> Yes, this is much saner.  There really shouldn't need to be an option,
> even; since the tools need to be modified anyway, just modify the actual
> memory map data structure itself.

yes,

kexec-tools will change that to E820_KDUMP_RESERVED (or other good name).

We only need to update kernel to get old max_pfn by
checking E820_KDUMP_RESERVED.

Yinghai
