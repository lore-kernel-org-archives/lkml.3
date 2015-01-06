Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbbAFMv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:51:57 -0500
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1079 "EHLO
	smtp-out-099.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751736AbbAFMv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:51:56 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7690
Message-ID: <54ABDA66.7040002@metafoo.de>
Date: Tue, 06 Jan 2015 13:51:50 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: =?windows-1252?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, dmaengine@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH, RFC] MIPS: jz4740: use dma filter function
References: <22569458.nE7JkNNnz3@wuerfel> <54ABBCE6.8060904@metafoo.de> <yw1xtx04f54r.fsf@unicorn.mansr.com>
In-Reply-To: <yw1xtx04f54r.fsf@unicorn.mansr.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 01:47 PM, Måns Rullgård wrote:
> Lars-Peter Clausen <lars@metafoo.de> writes:
>
>> On 01/05/2015 11:39 PM, Arnd Bergmann wrote:
>>> As discussed on the topic of shmobile DMA today, jz4740 is the only
>>> user of the slave_id field in dma_slave_config besides shmobile. This
>>> use is really incompatible with the way that other drivers use the
>>> dmaengine API, so we should get rid of it.
>>
>> Do you have a link to that discussion?
>>
>>>
>>> This adds a trivial filter function that uses the filter param to
>>> pass the dma type, and uses that in both drivers.
>>
>> In my opinion that's just from bad to worse. Using filter functions
>> isn't that great in the first place. And using them to pass data from
>> the consumer to the DMA provider is just a horrible abuse of the API.
>
> It seems to me the only sane way to use the dmaengine API is in
> conjunction with DT.

At the moment yes. For non DT we need something like the gpiod lookup tables 
that allow you to specify the assignment of the DMA channel in the machine 
driver.

- Lars


