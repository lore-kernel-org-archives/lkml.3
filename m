Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbbAGQR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:17:58 -0500
Received: from smtp-out-020.synserver.de ([212.40.185.20]:1049 "EHLO
	smtp-out-017.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754057AbbAGQR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:17:56 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5377
Message-ID: <54AD5C2F.1090501@metafoo.de>
Date: Wed, 07 Jan 2015 17:17:51 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        dmaengine@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-mmc@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH, RFC] MIPS: jz4740: use dma filter function
References: <22569458.nE7JkNNnz3@wuerfel> <2633187.PyovTNc8DC@wuerfel> <54AD42D0.4070402@metafoo.de> <10623722.YrKe6DgiSS@wuerfel>
In-Reply-To: <10623722.YrKe6DgiSS@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 05:13 PM, Arnd Bergmann wrote:
> On Wednesday 07 January 2015 15:29:36 Lars-Peter Clausen wrote:
>> On 01/06/2015 02:48 PM, Arnd Bergmann wrote:
>>> On Tuesday 06 January 2015 11:45:58 Lars-Peter Clausen wrote:
>>>> On 01/05/2015 11:39 PM, Arnd Bergmann wrote:
>>>>> As discussed on the topic of shmobile DMA today, jz4740 is the only
>>>>> user of the slave_id field in dma_slave_config besides shmobile. This
>>>>> use is really incompatible with the way that other drivers use the
>>>>> dmaengine API, so we should get rid of it.
>>>>
>>>> Do you have a link to that discussion?
>>>
>>> http://www.spinics.net/lists/linux-mmc/msg30069.html
>>
>> I'm really not comfortable with this patch, since it is a step back. But I
>> guess the end justify the means. So if it helps to get rid of slave_id I'm
>> ok with it, sooner or later jz4740 will be converted to DT so once that's
>> done the filter function can be removed again. But please put the filter
>> function in a non arch specific header so we can still compile test things.
>> And maybe note in the commit message that this is meant as a temporary hack.
>>
>
> Do you have a timeline for DT support? Maybe it's easier to just
> wait for the problem to solve itself.

2 to 3 upstream releases. I have the code and it is working, but the 
migration path has a lot of inter dependencies between different frameworks, 
so it is going to take a while until all is upstream.

- Lars

