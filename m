Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3KTJgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:36:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab3KTJgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:36:07 -0500
Date: Wed, 20 Nov 2013 11:36:04 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: mmu: delay mmu audit activation
Message-ID: <20131120093604.GA2108@redhat.com>
References: <1384892567-20134-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384892567-20134-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 03:22:47PM -0500, Sasha Levin wrote:
> We should not be using jump labels before they were initialized. Push back
> the callback to until after jump label initialization.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Applied, thanks.

> ---
>  arch/x86/kvm/mmu_audit.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
> index daff69e..1185fe7 100644
> --- a/arch/x86/kvm/mmu_audit.c
> +++ b/arch/x86/kvm/mmu_audit.c
> @@ -296,4 +296,4 @@ static struct kernel_param_ops audit_param_ops = {
>  	.get = param_get_bool,
>  };
>  
> -module_param_cb(mmu_audit, &audit_param_ops, &mmu_audit, 0644);
> +arch_param_cb(mmu_audit, &audit_param_ops, &mmu_audit, 0644);
> -- 
> 1.7.10.4

--
			Gleb.
