Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3K0PLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:11:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab3K0PLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:11:35 -0500
Date: Wed, 27 Nov 2013 10:10:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v7 2/2] Documentation, x86, apic, kexec: Add
 disable_cpu_apicid kernel parameter
Message-ID: <20131127151056.GJ18706@redhat.com>
References: <20131127020006.1493.86091.stgit@localhost6.localdomain6>
 <20131127020053.1493.54092.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127020053.1493.54092.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 11:00:53AM +0900, HATAYAMA Daisuke wrote:
> Add disable_cpu_apicid kernel parameter to disable the CPU with the
> specified number of initial APIC ID, mostly used for the kdump 2nd
> kernel to disable BSP to wake up multiple CPUs without causing system
> reset or hang due to sending INIT from AP to BSP.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>

I guess you don't require a separate patch for documentation. Just merge
it with previous patch. So this becomes a single patch fix and not a 
series.

Thanks
Vivek
> ---
>  Documentation/kernel-parameters.txt |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 50680a5..dd77bec 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -774,6 +774,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	disable=	[IPV6]
>  			See Documentation/networking/ipv6.txt.
>  
> +	disable_cpu_apicid= [X86,APIC,KEXEC,SMP]
> +			Format: <int>
> +			The number of initial APIC ID for the
> +			corresponding CPU to be disabled at boot,
> +			mostly used for the kdump 2nd kernel to
> +			disable BSP to wake up multiple CPUs without
> +			causing system reset or hang due to sending
> +			INIT from AP to BSP.
> +
>  	disable_ddw     [PPC/PSERIES]
>  			Disable Dynamic DMA Window support. Use this if
>  			to workaround buggy firmware.
