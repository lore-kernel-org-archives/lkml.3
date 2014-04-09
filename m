Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbaDIOVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:21:42 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37296 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaDIOVl convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 9 Apr 2014 10:21:41 -0400
Message-Id: <5345739202000078000073EA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 09 Apr 2014 15:21:38 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <boris.ostrovsky@oracle.com>
Cc: <david.vrabel@citrix.com>, <xen-devel@lists.xenproject.org>,
        <konrad.wilk@oracle.com>, <srostedt@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] x86/xen: Fix 32-bit PV guests's usage
 of kernel_stack
References: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.04.14 at 16:06, <boris.ostrovsky@oracle.com> wrote:
> --- a/arch/x86/xen/xen-asm_32.S
> +++ b/arch/x86/xen/xen-asm_32.S
> @@ -88,7 +88,11 @@ ENTRY(xen_iret)
>  	 * avoid having to reload %fs
>  	 */
>  #ifdef CONFIG_SMP
> +	pushw %fs
> +	movl $(__KERNEL_PERCPU), %eax
> +	movl %eax, %fs
>  	GET_THREAD_INFO(%eax)
> +	popw %fs

I don't think it's guaranteed that this can't fault.

Jan

