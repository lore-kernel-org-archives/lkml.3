Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaFFRDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:03:01 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:43619 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaFFRC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:02:59 -0400
X-AuditID: cbfec37c-b7fd06d000004f49-62-5391f4414001
Message-id: <5391F438.90703@samsung.com>
Date: Fri, 06 Jun 2014 11:02:48 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Eli Billauer <eli.billauer@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Joerg Roedel <joro@8bytes.org>, devel@driverdev.osuosl.org,
        discuss@x86-64.org, linux-kernel@vger.kernel.org, bhelgaas@google.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
 <538E3D04.9060808@samsung.com> <20140603233907.GB23880@8bytes.org>
 <20140604140408.GC5004@htj.dyndns.org> <20140604141211.GC23880@8bytes.org>
 <20140604141416.GD5004@htj.dyndns.org> <538F3548.4050101@gmail.com>
 <20140604212525.GE23880@8bytes.org> <5391A9C2.3040602@gmail.com>
 <20140606160103.GG15110@kroah.com> <5391EA92.9050306@gmail.com>
In-reply-to: <5391EA92.9050306@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.251]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+wr67jl4nBBm+OK1gsacqw2HPmF7vF
	v7dvmC36+xYxWjQvXs9msWC/tUXn7A3sFpd3zWGzODvvOJvFr+VHGR24PJ4cnMfkcW/fYRaP
	nbPusnss2FTqsWlVJ5vH/rlr2D0m31jO6PF5k5zH0nVdzAGcUVw2Kak5mWWpRfp2CVwZ/6et
	Zy54JlRxpec6WwPjK74uRk4OCQETiZmnP7NB2GISF+6tB7OFBJYxSty4Vghh9zJJtP9g7WLk
	ArK3MUpM7fsIVMTBwSugIdGzPw6khkVAVeLe8xNgvWwC6hKfX+9gh+iVk2haspoZpFxUIELi
	8QUhkDCvgKDEj8n3WEBsEQF/iSerbjODjGcWaGOSuPh2L1hCWCBYYvudpUwQe+8xS/x4egMs
	wSmgKfHiXw/YAmYBa4mVk7YxQtjyEpvXvGWGWKws8efyKSaQxRJA9u2vYRMYRWYh2T0LSfcs
	JN0LGJlXMYqVFicXFCelp1YY6xUn5haX5qXrJefnbmKERGHNDsZ7X20OMQpwMCrx8Ab0TwgW
	Yk0sK67MPcQowcGsJMLL1jwxWIg3JbGyKrUoP76oNCe1+BAjEwenVAOjEt8Zkfr1+dd+c//j
	uXSnwWiuzcz/J4rlZMxmznkqZi/Zd/iMJ/v98/MctZf+flfgbMjOuos59/gNDs/NiYF/1kX4
	bH96+ff9d133EvbFJp0tUPlX80PwkaJ7KftR6e8MK/PebmmTV2v+7dTzq8hi9bN9R/ijD++4
	8fGz4jvTqLjb6pH5yUI3lViKMxINtZiLihMB6jKr+6ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 10:21 AM, Eli Billauer wrote:
> On 06/06/14 19:01, Greg KH wrote:
>>> Please try to put yourself in my position: I have a driver that I care
>>> >  about, which works fine for a few years. It's based upon
>>> dma_map_single(),
>>> >  which seems to be the common way to get non-coherent memory, even
>>> for the
>>> >  driver's entire lifespan. I realize that dma_alloc_* was the
>>> intended way to
>>> >  do it, but fact is that dma_map_* has become the common choice.
>>>
>> Is your driver in the kernel tree?  If not, you really are on your own :(
>>
> It's the Xillybus driver in the staging area. I don't know if this
> counts for being in the kernel tree...
>
> The suggested patchset would allow replacing my use of dma_map_single()
> with a managed version of that function. This will clean the driver's
> code considerably.
>
> But I think that the discussion here is if it's valid to use
> dma_map_single() for a device-permanent DMA mapping, or if
> dma_alloc_noncoherent() is the only way. If the answer is no, there's
> quite obviously no point in a devres version for that function.
>

Eli,

dma_map_single() and dma_unmap_single() are streaming DMA APIs. These
are intended for one DMA transfer and unmapped right after it is done.

dma buffers are limited shared resources for streaming that are
shared by several drivers. Hence the need for use and release
model.

Please refer to the Using Streaming DMA mappings in DMA-API-HOWTO.txt

"- Streaming DMA mappings which are usually mapped for one DMA
   transfer, unmapped right after it (unless you use dma_sync_* below)
   and for which hardware can optimize for sequential accesses.

   This of "streaming" as "asynchronous" or "outside the coherency
   domain".

   Good examples of what to use streaming mappings for are:

         - Networking buffers transmitted/received by a device.
         - Filesystem buffers written/read by a SCSI device."


If I understand your intended usage correctly, you are looking to
allocate and hold the buffers for the lifetime of the driver. For
such cases, dma_alloc_*() interfaces are the ones to use.

Please also refer to DMA-API.txt as well. Hope this helps.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
