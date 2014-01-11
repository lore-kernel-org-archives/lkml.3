Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaAKU7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:59:50 -0500
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:55442 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751653AbaAKU7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:59:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3167:3352:3622:3865:3867:3870:3871:3872:3874:4250:4321:5007:7576:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cave50_8f53ed4c4fa0c
X-Filterd-Recvd-Size: 1861
Message-ID: <1389473982.2537.84.camel@joe-AO722>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        Toshi Kani <toshi.kani@hp.com>
Date: Sat, 11 Jan 2014 12:59:42 -0800
In-Reply-To: <1389473370-1940-2-git-send-email-bp@alien8.de>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
	 <1389473370-1940-2-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-11 at 21:49 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> With reusing the ->trampoline_pgd page table for mapping EFI regions in
> order to use them after having switched to EFI virtual mode, it is very
> useful to be able to dump aforementioned page table in dmesg. This adds
> that functionality through the walk_pgd_level() interface which can be
> called from somewhere else.
[]
> diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
[]
> @@ -306,6 +326,11 @@ static void walk_pgd_level(struct seq_file *m)
>  	int i;
>  	struct pg_state st;
>  
> +	if (pgd) {
> +		start = pgd;
> +		dump_to_dmesg = true;
> +	}

	else
		dump_to_dmesg = false;

?


