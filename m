Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3GQTi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:38:29 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:53413 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab3GQTi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:38:28 -0400
Date: Wed, 17 Jul 2013 21:38:26 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: commit f8f559422b (KVM: MMU: fast invalidate all mmio sptes)
 causes hang
Message-ID: <20130717193826.GA360@x4>
References: <20130717163215.GA359@x4>
 <20130717164232.GI13732@redhat.com>
 <20130717165743.GA357@x4>
 <A242AFC1-86E6-4716-8DF7-6FD169DB6EC8@gmail.com>
 <20130717184226.GA358@x4>
 <20130717185539.GK13732@redhat.com>
 <20130717190029.GA362@x4>
 <A162C863-8D7A-4346-AECA-4509AC9BC7C0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A162C863-8D7A-4346-AECA-4509AC9BC7C0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.07.18 at 03:27 +0800, Xiao Guangrong wrote:
> 
> Could you please try this:
> 
> index 460b9c6..16d1578 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2952,6 +2952,9 @@ static bool page_fault_can_be_fast(u32 error_code)
>               !(error_code & PFERR_WRITE_MASK))
>                 return false;
>  
> +       if (error_code & PFERR_RSVD_MASK)
> +               return false;
> +
>         return true;
>  }

This fixes the issue for me. Many thanks Xiao.

-- 
Markus
