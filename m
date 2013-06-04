Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab3FDJFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:05:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab3FDJFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:05:21 -0400
Date: Tue, 4 Jun 2013 12:05:08 +0300
From: Gleb Natapov <gleb@redhat.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/1] KVM: add kvm_para_available to asm-generic/kvm_para.h
Message-ID: <20130604090508.GL4725@redhat.com>
References: <1369222162-4857-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369222162-4857-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 12:29:22PM +0100, James Hogan wrote:
> According to include/uapi/linux/kvm_para.h architectures should define
> kvm_para_available, so add an implementation to asm-generic/kvm_para.h
> which just returns false.
> 
What is this fixing? The only user of kvm_para_available() that can
benefit from this is in sound/pci/intel8x0.c, but I do not see follow up
patch to use it there.

> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/asm-generic/kvm_para.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/asm-generic/kvm_para.h b/include/asm-generic/kvm_para.h
> index 9d96605..fa25bec 100644
> --- a/include/asm-generic/kvm_para.h
> +++ b/include/asm-generic/kvm_para.h
> @@ -18,4 +18,9 @@ static inline unsigned int kvm_arch_para_features(void)
>  	return 0;
>  }
>  
> +static inline bool kvm_para_available(void)
> +{
> +	return false;
> +}
> +
>  #endif
> -- 
> 1.8.1.2
> 

--
			Gleb.
