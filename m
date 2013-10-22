Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3JVQgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:36:40 -0400
Received: from smtprelay0023.hostedemail.com ([216.40.44.23]:36369 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753987Ab3JVQgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:36:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:334:355:368:369:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3868:3870:4321:4605:4837:5007:7576:7652:10004:10400:10848:11026:11232:11473:11658:11914:12296:12517:12519:12740:13069:13146:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glue20_73d5788c1854b
X-Filterd-Recvd-Size: 1870
Message-ID: <1382459794.2041.91.camel@joe-AO722>
Subject: Re: [PATCH 2/3] Kbuild: Handle longer symbols in kallsyms.c
From: Joe Perches <joe@perches.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Tue, 22 Oct 2013 09:36:34 -0700
In-Reply-To: <1382456783-22826-3-git-send-email-andi@firstfloor.org>
References: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
	 <1382456783-22826-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 08:46 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Also warn for too long symbols

[]

> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
[]
> @@ -27,7 +27,7 @@
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
>  #endif
>  
> -#define KSYM_NAME_LEN		128
> +#define KSYM_NAME_LEN		256

Maybe nicer to get these #defines via #include <>
to avoid getting out of sync.
 
>  struct sym_entry {
>  	unsigned long long addr;
> @@ -118,6 +118,12 @@ static int read_symbol(FILE *in, struct sym_entry *s)
>  			fprintf(stderr, "Read error or end of file.\n");
>  		return -1;
>  	}
> +	if (strlen(str) > KSYM_NAME_LEN) {
> +		fprintf(stderr, "Symbol %s too long for kallsyms.\n"
> +                                "Please increase KSYM_NAME_LEN both in kernel and kallsyms.c",
> +			str);

Missing newline?

Also maybe nicer to show symbol length and KSYM_NAME_LEN values.


