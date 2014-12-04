Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbaLDSIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:08:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928AbaLDSIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:08:13 -0500
Date: Thu, 4 Dec 2014 19:08:07 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH 9/9] kvm: vmx: add nested virtualization support for
 xsaves
Message-ID: <20141204180806.GF18651@potion.brq.redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
 <1417708634-24333-10-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417708634-24333-10-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-04 16:57+0100, Paolo Bonzini:
> From: Wanpeng Li <wanpeng.li@linux.intel.com>
> 
> Add vmcs12 support for xsaves.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

> +	case EXIT_REASON_XSAVES: case EXIT_REASON_XRSTORS:
> +		/*
> +		 * This should never happen, since it is not possible to
> +		 * set XSS to a non-zero value---neither in L1 nor in L2.
> +		 * If if it were, XSS would have to be checked against
> +		 * the XSS exit bitmap in vmcs12.
> +		 */

We could WARN then.

> +		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES);
>  	default:
>  		return 1;
>  	}
