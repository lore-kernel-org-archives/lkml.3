Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936861Ab3DIDZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:25:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934544Ab3DIDZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:25:54 -0400
Message-ID: <51638A27.3040607@redhat.com>
Date: Tue, 09 Apr 2013 11:25:27 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] x86, kdump: Set crashkernel_low automatically
References: <1365113821-22749-1-git-send-email-yinghai@kernel.org> <1365113821-22749-2-git-send-email-yinghai@kernel.org> <51626D3D.4000907@redhat.com> <CAE9FiQUsMGmF2PXMD2W+f7oYBJVudccxoWnisLEsDxXzGgoi0g@mail.gmail.com>
In-Reply-To: <CAE9FiQUsMGmF2PXMD2W+f7oYBJVudccxoWnisLEsDxXzGgoi0g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 02:37 AM, Yinghai Lu wrote:
> On Mon, Apr 8, 2013 at 12:09 AM, Dave Young <dyoung@redhat.com> wrote:
>>> We have now modified crashkernel=X to allocate memory beyong 4G (if
>>> available) and do not allocate low range for crashkernel if the user
>>> does not specify that with crashkernel_low=Y.  This causes regression
>>> if iommu is not enabled.  Without iommu, swiotlb needs to be setup in
>>> first 4G and there is no low memory available to second kernel.
>>
>> Is it possible to reuse the 1st kernel swiotlb region in 2nd capture
>> kernel if it's available?
> 
> If the first kernel is using intel iommu, and swiotlb is freed after intel
> iommus is enabled in first kernel.

Ok, also it's hard to handle such as 1st kernel iommu=off, 2nd kernel
iommu=on etc.

I have another question, under x86_64 consider 1st kernel memory < 4G,
is the swiotlb memory still necessary?

> 
>>
>>>
>>> Set crashkernel_low automatically if the user does not specify that.
>>>
>>> For system that does support IOMMU with kdump properly, user could
>>> specify crashkernel_low=0 to save that 72M low ram.
>>
>> How about make swiotlb size tunable in 1st kernel as well such as adding
>> a swiotlb_size= to cmdline, if it's set in 1st kernel crashkernel
>> reserving code can take it automaticlly.
>>
> can not understand this.

This maybe out of topic. I means swiotlb size is hardcoded, I'm thinking
how about make it configurable via kconfig or boot cmdline.

> 
> Thanks
> 
> Yinghai
> 


-- 
Thanks
Dave


