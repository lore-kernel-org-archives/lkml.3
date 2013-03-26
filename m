Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab3CZMNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:13:02 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43001 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972Ab3CZMM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:12:59 -0400
Date: Tue, 26 Mar 2013 17:36:26 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, oleg@redhat.com,
        benh@kernel.crashing.org, ppcdev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 2/4] uprobes: refuse uprobe on trap variants
Message-ID: <20130326120626.GB20399@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130322151627.GB20010@in.ibm.com>
 <20130322151758.GC20010@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130322151758.GC20010@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032612-2876-0000-0000-000006C0D718
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli <ananth@in.ibm.com> [2013-03-22 20:47:58]:

> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Refuse to place a uprobe if a trap variant already exists in the
> file copy at the address.
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-3.9-rc3/kernel/events/uprobes.c
> ===================================================================
> --- linux-3.9-rc3.orig/kernel/events/uprobes.c
> +++ linux-3.9-rc3/kernel/events/uprobes.c
> @@ -573,7 +573,7 @@ static int prepare_uprobe(struct uprobe
>  		goto out;
> 
>  	ret = -ENOTSUPP;
> -	if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
> +	if (is_trap_insn((uprobe_opcode_t *)uprobe->arch.insn))
>  		goto out;
> 
>  	ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);

-- 
Thanks and Regards
Srikar Dronamraju

