Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaFFQWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:22:43 -0400
Received: from mxout1.netvision.net.il ([194.90.9.20]:47264 "EHLO
	mxout1.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaFFQWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:22:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <5391EA92.9050306@gmail.com>
Date: Fri, 06 Jun 2014 19:21:38 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Joerg Roedel <joro@8bytes.org>, devel@driverdev.osuosl.org,
        Shuah Khan <shuah.kh@samsung.com>, discuss@x86-64.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
 <538E3D04.9060808@samsung.com> <20140603233907.GB23880@8bytes.org>
 <20140604140408.GC5004@htj.dyndns.org> <20140604141211.GC23880@8bytes.org>
 <20140604141416.GD5004@htj.dyndns.org> <538F3548.4050101@gmail.com>
 <20140604212525.GE23880@8bytes.org> <5391A9C2.3040602@gmail.com>
 <20140606160103.GG15110@kroah.com>
In-reply-to: <20140606160103.GG15110@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/14 19:01, Greg KH wrote:
>> Please try to put yourself in my position: I have a driver that I care
>> >  about, which works fine for a few years. It's based upon dma_map_single(),
>> >  which seems to be the common way to get non-coherent memory, even for the
>> >  driver's entire lifespan. I realize that dma_alloc_* was the intended way to
>> >  do it, but fact is that dma_map_* has become the common choice.
>>
> Is your driver in the kernel tree?  If not, you really are on your own :(
>
It's the Xillybus driver in the staging area. I don't know if this 
counts for being in the kernel tree...

The suggested patchset would allow replacing my use of dma_map_single() 
with a managed version of that function. This will clean the driver's 
code considerably.

But I think that the discussion here is if it's valid to use 
dma_map_single() for a device-permanent DMA mapping, or if 
dma_alloc_noncoherent() is the only way. If the answer is no, there's 
quite obviously no point in a devres version for that function.

Regards,
    Eli
> greg k-h
>
>


