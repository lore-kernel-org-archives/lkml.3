Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab3LKHp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:45:57 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:39661 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3LKHp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:45:56 -0500
Message-ID: <52A81830.3000305@gmail.com>
Date: Wed, 11 Dec 2013 09:45:52 +0200
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Steven Luo <steven@steven676.net>
CC: gregkh@linuxfoundation.org, nico@ngolde.de, fabs@goesec.de,
        omar.ramirez@copitl.com, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        tony@atomide.com, felipe.contreras@gmail.com,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Use vm_iomap_memory for mmap-ing
 instead of remap_pfn_range
References: <1386014416-4556-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <20131207234912.GA1245@steven676.net>
In-Reply-To: <20131207234912.GA1245@steven676.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08.12.2013 01:49, Steven Luo wrote:
> This patch causes problems with DSP codecs on OMAP3 devices running
> Android -- specifically, when the decoder is cleaning up after itself,
> munmap() of the mapped area fails, leading to a memory leak which
> eventually crashes the system.
>
> As far as I can tell, the code with this patch applied reduces to
> (ignoring checks and such)
>
> remap_pfn_range(vma, vma->vm_start,
> 	(pdata->phys_mempool_base >> PAGE_SHIFT) + vma->vm_pgoff,
> 	vma->vm_end - vma->vm_start,
> 	vma->vm_page_prot);
>
> whereas the original was
>
>> -	status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>> -				 vma->vm_end - vma->vm_start,
>> -				 vma->vm_page_prot);
> We're subtracting (pdata->phys_mempool_base >> PAGE_SHIFT) from
> vma->vm_pgoff before calling vm_iomap_memory() to address the issue --
> if that's satisfactory to everyone involved, I can submit the following
> patch.
>
>
Hi,

I can pick your changes and re-send the original patch with them 
incorporated if there are no objections. Are you fine with that?

Regards,
Ivo
