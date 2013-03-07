Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab3CGBFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:05:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab3CGBFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:05:43 -0500
Message-ID: <5137E779.5050904@zytor.com>
Date: Wed, 06 Mar 2013 17:03:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: akpm@linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mm-commits@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        liwanp@linux.vnet.ibm.com, mingo@kernel.org, tj@kernel.org,
        vgupta@synopsys.com
Subject: Re: + memblock-add-assertion-for-zero-allocation-alignment.patch
 added to -mm tree
References: <20130306224405.8160D5A4082@corp2gmr1-2.hot.corp.google.com> <CAE9FiQVAnR08U=ywUzk_4fkSh_mz6sZqtwWg02YzzF_cbN45rQ@mail.gmail.com>
In-Reply-To: <CAE9FiQVAnR08U=ywUzk_4fkSh_mz6sZqtwWg02YzzF_cbN45rQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 04:07 PM, Yinghai Lu wrote:
>>
>>  mm/memblock.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff -puN mm/memblock.c~memblock-add-assertion-for-zero-allocation-alignment mm/memblock.c
>> --- a/mm/memblock.c~memblock-add-assertion-for-zero-allocation-alignment
>> +++ a/mm/memblock.c
>> @@ -771,6 +771,9 @@ static phys_addr_t __init memblock_alloc
>>  {
>>         phys_addr_t found;
>>
>> +       if (WARN_ON(!align))
>> +               align = __alignof__(long long);
>> +
>>         /* align @size to avoid excessive fragmentation on reserved array */
>>         size = round_up(size, align);
> 
> Hi, Peter,
> 
> Do you agree that we should check align in round_up()?
> 

Not in round_up(), that is used in way too many places.  Doing it in
memblock_alloc() might make sense.

	-hpa

