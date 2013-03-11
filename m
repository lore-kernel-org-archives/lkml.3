Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3CKKE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:04:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab3CKKEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:04:25 -0400
Date: Mon, 11 Mar 2013 12:04:17 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Ioan Orghici <ioanorghici@gmail.com>
Cc: mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Ioan Orghici <ioan.orghici@gmail.com>
Subject: Re: [PATCH] kvm: remove cast for kmalloc return value
Message-ID: <20130311100417.GD31619@redhat.com>
References: <1362923160-26300-1-git-send-email-ioan.orghici@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362923160-26300-1-git-send-email-ioan.orghici@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 03:46:00PM +0200, Ioan Orghici wrote:
> Signed-off-by: Ioan Orghici<ioan.orghici@gmail.com>
> ---
>  arch/x86/kvm/vmx.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 7cc566b..35c2c8f 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5261,8 +5261,7 @@ static struct loaded_vmcs *nested_get_current_vmcs02(struct vcpu_vmx *vmx)
>  	}
>  
>  	/* Create a new VMCS */
> -	item = (struct vmcs02_list *)
> -		kmalloc(sizeof(struct vmcs02_list), GFP_KERNEL);
> +	item = kmalloc(sizeof(struct vmcs02_list), GFP_KERNEL);
>  	if (!item)
>  		return NULL;
>  	item->vmcs02.vmcs = alloc_vmcs();
Applied, thanks.

--
			Gleb.
