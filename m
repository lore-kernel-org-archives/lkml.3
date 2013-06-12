Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3FLVda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:33:30 -0400
Received: from smtp6.ono.com ([62.42.230.189]:36184 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755220Ab3FLVd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:33:29 -0400
Message-ID: <51B8E926.3030504@ono.com>
Date: Wed, 12 Jun 2013 23:33:26 +0200
From: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallon@ono.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Thunderbird/22.0
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: Accessing more than 2GB of memory with a 32 bit kernel
References: <1371056055.24587.140661243104889.29DDEEB4@webmail.messagingengine.com> <51B8D59B.1040801@redhat.com>
In-Reply-To: <51B8D59B.1040801@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 10:10 PM, Rik van Riel wrote:
> On 06/12/2013 12:54 PM, Simon Brown wrote:
>> Hello,
>>
>> For the sake of an old prototype peripheral I'm using a non PAE 32 bit
>> x86 kernel and I'm having trouble accessing memory above 2 GB. The
>> system has 4GB installed and all is well with a PAE kernel.
>>
>> I'm obviously expecting to lose some memory due to memory mapped devices
>> but I wasn't expecting to lose 2GB. Instead I'm suspecting a BIOS bug.
>> The system reports:
>> free -m
>>               total       used       free     shared    buffers
>>               cached
>> Mem:          2012        491       1521          0         40
>> 277
>>
>> The mtrr table looked odd so I enabled sanitisation:
>> [    0.000000] original variable MTRRs
>> [    0.000000] reg 0, base: 2GB, range: 2GB, type UC
>> [    0.000000] reg 1, base: 0GB, range: 4GB, type WB
>> [    0.000000] reg 2, base: 4GB, range: 2GB, type WB
>> [    0.000000] total RAM covered: 4096M
>> [    0.000000] Found optimal setting for mtrr clean up
>> [    0.000000]  gran_size: 64K  chunk_size: 64K         num_reg: 2
>> lose cover RAM: 0G
>> [    0.000000] New variable MTRRs
>> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
>> [    0.000000] reg 1, base: 4GB, range: 2GB, type WB
>>
>> I don't understand the gap in the new table.
>
> Check the e820 table. Chances are the BIOS is reserving 2GB to
> map various devices (especially video cards) below the 4GB limit.
>
>

Acording to manual, that mobo has an option to "Memory remap feature"
in BIOS that looks like that...

-- 
J.A. Magallon <jamagallon()ono!com>        \               Winter is coming...
