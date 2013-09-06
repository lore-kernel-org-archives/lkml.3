Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3IFOF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:05:57 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54395 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab3IFOF4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 6 Sep 2013 10:05:56 -0400
Message-Id: <5229FD6A02000078000F119C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 06 Sep 2013 15:06:02 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, "xen-devel" <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/p2m: Export set_phys_to_machine.
References: <1378476042-4821-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1378476042-4821-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.09.13 at 16:00, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> We have already exported 'get_phys_to_machine' and there are
> third-party drivers that depend on this other symbol. As such
> lets make this balanced and also export this symbol.

I tend to disagree: Allowing external modules read access to some
internal state is quite different from also allowing them to alter it.

Jan

> Reported-by: Yuval Shaia <yuval.shaia@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/p2m.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 0d4ec35..cdb96bc 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -847,6 +847,7 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>  
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(set_phys_to_machine);
>  
>  #define M2P_OVERRIDE_HASH_SHIFT	10
>  #define M2P_OVERRIDE_HASH	(1 << M2P_OVERRIDE_HASH_SHIFT)
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 



