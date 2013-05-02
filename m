Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761200Ab3EBS7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:59:32 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49808 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760854Ab3EBS7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:59:31 -0400
Message-ID: <5182B790.6090907@sgi.com>
Date: Thu, 02 May 2013 11:59:28 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: David Henningsson <david.henningsson@canonical.com>,
        Stephen Warren <swarren@nvidia.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH]: x86_64, audio: Fix system panic when DMA > 40 bits
References: <1367435048-66137-1-git-send-email-travis@sgi.com> <518205A9.1050409@canonical.com> <5182AE68.9010905@wwwdotorg.org>
In-Reply-To: <5182AE68.9010905@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/2/2013 11:20 AM, Stephen Warren wrote:
> On 05/02/2013 12:20 AM, David Henningsson wrote:
>> On 05/01/2013 09:04 PM, Mike Travis wrote:
>>> The audio driver mistakenly allows 64 bit addresses to be created for
>>> the audio driver on Nvidia GPUs.  Unfortunately, the hardware normally
>>> only supports up to 40 bits of DMA.  This can cause system panics as
>>> well as misdirected data when the address is > 40 bits as the upper
>>> part the address is truncated.
>>
>> Thanks for this patch. Stephen Warren, is this something you can
>> confirm/deny, and do you know what range of hardware this actually
>> applies to?
> 
> It's certainly plausible that the GPU's internal physical addresses are
> less than a full 64-bits, and this probably affects PCI accesses too.
> 

I haven't noticed any other problems with MMIOH accesses.  The
problem of DMA32 addresses certainly affects us though audio is
not a high priority on UV(*) except in specific applications (like
Media Servers, etc.]  Accesses to the GPU and GPGPU are much more
common.

(* http://www.sgi.com/products/servers/uv/)
