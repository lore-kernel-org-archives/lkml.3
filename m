Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaFDPEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:04:40 -0400
Received: from mxout1.netvision.net.il ([194.90.9.20]:53322 "EHLO
	mxout1.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaFDPEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:04:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <538F3548.4050101@gmail.com>
Date: Wed, 04 Jun 2014 18:03:36 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Tejun Heo <tj@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>, Shuah Khan <shuah.kh@samsung.com>,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        discuss@x86-64.org
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
 <538E3D04.9060808@samsung.com> <20140603233907.GB23880@8bytes.org>
 <20140604140408.GC5004@htj.dyndns.org> <20140604141211.GC23880@8bytes.org>
 <20140604141416.GD5004@htj.dyndns.org>
In-reply-to: <20140604141416.GD5004@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I believe that I need a managed dma_map_single() my own driver, which 
doesn't fall in the case of a single use: The driver allocates its 
buffers with __get_free_pages() (or the to-be managed version of it). 
Then it cuts the allocated memory into smaller buffers (in some cases, 
and with certain alignment rules), and  then calls dma_map_single() to 
do the DMA mapping for each. The buffers are held along the driver's 
lifetime, with DMA sync API juggling control back and forth to the 
hardware. Note that the DMA is noncoherent.

Once could argue, that since dma_map_noncoherent() calls 
__get_free_pages() under the hood, I could request the larger chunk from 
dma_map_noncoherent(), and cut it into smaller DMA buffers. My concern 
is that the dma_sync_single_*() functions expect a DMA handle, not a 
physical address I've made up with my own buffer splitting. I don't see 
any problem with this trick on platforms I've worked with, but I'm not 
sure if this is the proper way to go. dma_map_single(), on the other 
hand, returns a DMA handle.

The DMA pool functions could be interesting, but I understand that they 
would supply me with coherent memory only.

Anything I missed?

Thanks,
    Eli

On 04/06/14 17:14, Tejun Heo wrote:
> Hello,
>
> On Wed, Jun 04, 2014 at 04:12:11PM +0200, Joerg Roedel wrote:
>    
>> Yes, but those drivers usually get DMA buffers at init time with the
>> dma_alloc_* interfaces. The dma_map_* interfaces discussed here belong
>> to the streaming DMA-API, so they are usually used for only one DMA
>> transaction before dma_unmap_* is called on them.
>>
>> A devm interface for the dma_alloc_* family of functions would
>> actually make sense, but not for the dma_map_* functions.
>>      
> Ah, okay.  Fair enough.
>
> Thanks.
>
>    


