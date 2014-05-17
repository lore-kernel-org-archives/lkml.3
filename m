Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547AbaEQMfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 08:35:44 -0400
Received: from mxout5.netvision.net.il ([194.90.6.65]:33065 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389AbaEQMfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 08:35:43 -0400
X-Greylist: delayed 924 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2014 08:35:43 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <537753C9.3060101@gmail.com>
Date: Sat, 17 May 2014 15:19:21 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] dma-mapping: Add devm_ interface for dma_map_single()
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
 <1400228799-8832-3-git-send-email-eli.billauer@gmail.com>
 <20140516210805.GO5379@htj.dyndns.org>
In-reply-to: <20140516210805.GO5379@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On 17/05/14 00:08, Tejun Heo wrote:
>
> Don't we wanna map the underlying operation - dma_map_single_attrs() -
> instead?
>    

I'll resubmit this patch promptly, with a follow-up patch for the diff 
to implement dmam_map_single_attrs() instead. Plus a define-statement 
for dmam_map_single(). I can't test the case of a non-NULL value for 
@attrs however.

>    
>> +	if (dma_mapping_error(dev, dma_handle)) {
>> +		devres_free(dr);
>> +		return 0;
>>      
> Can't we just keep returning dma_handle?  Even if that means invoking
> ->mapping_error() twice?  It's yucky to have subtly different error
> return especially because in most cases it won't fail.
>    
Yucky it is indeed. There are however two problems with keeping the 
existing API:

* What to do if devres_alloc() fails. How do I signal back an error? The 
only way I can think of is returning zero. But if the caller should know 
that zero means failure, I've already broken the API. I might as well 
return zero for any kind of failure.
* It seems like a lot of dma_mapping_error() implementations always 
return no-error, since the DMA mapping can't fail on specific 
architectures. If callers use dma_mapping_error(), the possible 
devres_alloc() failure will be missed.

By the way, where I've seen dma_mapping_error() doing something, it 
checks for dma_handle == 0.

Submitting updated patches for the DMA mapping part soon.

Regards,
    Eli


