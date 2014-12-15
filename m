Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750814AbaLOMGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:06:10 -0500
Received: from smtp.citrix.com ([66.165.176.89]:19951 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbaLOMGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:06:08 -0500
X-IronPort-AV: E=Sophos;i="5.07,579,1413244800"; 
   d="scan'208";a="204402245"
Message-ID: <548ECE9B.3040105@citrix.com>
Date: Mon, 15 Dec 2014 12:05:47 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <david.vrabel@citrix.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4/4] xen: use generated hypercall symbols
 in arch/x86/xen/xen-head.S
References: <1418321065-10212-1-git-send-email-jgross@suse.com> <1418321065-10212-5-git-send-email-jgross@suse.com>
In-Reply-To: <1418321065-10212-5-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/14 18:04, Juergen Gross wrote:
> Instead of manually list each hypercall in arch/x86/xen/xen-head.S
> use the auto generated symbol list.
> 
> This also corrects the wrong address of xen_hypercall_mca which was
> located 32 bytes higher than it should.
> 
> Symbol addresses have been verified to match the correct ones via
> objdump output.
[...]
> +
> +#define HYPERCALL(n) \
> +	.equ xen_hypercall_##n, hypercall_page + __HYPERVISOR_##n * 32; \
> +	.type xen_hypercall_##n, function; .size xen_hypercall_##n, 32
> +#include <asm/xen-hypercalls.h>
> +#undef HYPERCALL

The gas manual[1] suggests the syntax you've used for .type is invalid
and suggest using .type <name>, STT_FUNC

> +
>  	.balign PAGE_SIZE

You can remove this .balign.

David

[1] https://sourceware.org/binutils/docs/as/Type.html#Type
