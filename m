Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3K2DMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 22:12:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3K2DME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 22:12:04 -0500
Date: Fri, 29 Nov 2013 11:10:48 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131129031048.GE4318@dhcp-16-252.nay.redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13 at 12:50pm, Vivek Goyal wrote:
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index 4eabc16..fb41b73 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -22,6 +22,13 @@
>  #include <asm/mmu_context.h>
>  #include <asm/debugreg.h>
>  
> +/* arch dependent functionality related to kexec file based syscall */
> +static struct kexec_file_type kexec_file_type[]={
> +	{"", NULL, NULL, NULL, NULL},
> +};
> +
> +
> +void *arch_kexec_kernel_image_load(struct kimage *image, char *kernel,
> +			unsigned long kernel_len, char *initrd,
> +			unsigned long initrd_len, char *cmdline,
> +			unsigned long cmdline_len)
> +{
> +	int idx = image->file_handler_idx;
> +
> +	if (idx < 0)
> +		return ERR_PTR(-ENOEXEC);
> +
> +	return kexec_file_type[idx].load(image, kernel, kernel_len, initrd,
> +					initrd_len, cmdline, cmdline_len);
> +}
> +
> +int arch_image_file_post_load_cleanup(struct kimage *image)
> +{

Hi Vivek,

This function is defined as one of arch specific fucntion set, why don't
we name it in a unified prefix as others.

And name of the default dummy function in kernel/kexec.c is not consistent
with the arch specific one, so currently
arch_image_file_post_load_cleanup of x86 arch is not called. Please
consider wihch one need be changed.

> +
> +void __attribute__ ((weak))
> +arch_kimage_file_post_load_cleanup(struct kimage *image)
> +{
> +	return;
> +}
> +


