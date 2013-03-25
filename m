Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3CYL3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab3CYL3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:29:31 -0400
Message-ID: <5150350A.5050002@redhat.com>
Date: Mon, 25 Mar 2013 19:29:14 +0800
From: WANG Chao <chaowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: zhouzhouyi@gmail.com
CC: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com, yizhouzhou@ict.ac.cn
Subject: Re: [PATCH 1/1 v1] the recommended crash memory reservation is too
 small for x86_64.
References: <1364209009-11592-1-git-send-email-zhouzhouyi@gmail.com>
In-Reply-To: <1364209009-11592-1-git-send-email-zhouzhouyi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 06:56 PM, zhouzhouyi@gmail.com wrote:
> From: root <root@zzy-Lenovo.(none)>
> 
> 
>  On Documentation/kdump/kdump.txt, section Boot into  System Kernel: On x86 and x86_64, use
>  "crashkernel=64M@16M", but some OSes like ubuntu 12.10 use ram fs larger than 64M, so in these cases the
>  memory reserved for crashkernel should be at least 128M.

People use different initramfs generators for different purpose. That means
the size of initramfs and also its memory consuming can vary very much from
each other. You just can't list all these generators and their recommended
reserved memory here. Though I have to say crashkernel=128M is good choice.

I think it would be better to leave this to user or distribution itself to
determine how much memory should be reserved for crash kernel, then export
this value to kernel in some ways.

Thanks,
WANG Chao

> 
> 
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> ---
>  Documentation/kdump/kdump.txt |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index 13f1aa0..1e850e0 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -290,7 +290,9 @@ Boot into System Kernel
>     "crashkernel=64M@16M" tells the system kernel to reserve 64 MB of memory
>     starting at physical address 0x01000000 (16MB) for the dump-capture kernel.
>  
> -   On x86 and x86_64, use "crashkernel=64M@16M".
> +   On x86 and x86_64, use "crashkernel=64M@16M" (some OSes use init ram fs larger
> +than 64M, for example ubuntu-12.10, use crashkernel=128M@16M instead, or dump-capture
> +kernel will out of memory).
>  
>     On ppc64, use "crashkernel=128M@32M".
>  
> 

