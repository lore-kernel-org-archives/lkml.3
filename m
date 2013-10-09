Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab3JICaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 22:30:14 -0400
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:43226 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751255Ab3JICaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 22:30:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3868:3871:4321:4605:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12295:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none
X-HE-Tag: queen69_75897b63ba01d
X-Filterd-Recvd-Size: 2101
Message-ID: <1381285806.23937.51.camel@joe-AO722>
Subject: Re: [PATCH v2] vsprintf: Check real user/group id for %pK
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 19:30:06 -0700
In-Reply-To: <5254BDD0.7040001@gmail.com>
References: <5254A034.5020700@gmail.com>
	 <1381279758.23937.42.camel@joe-AO722> <1381282200.23937.45.camel@joe-AO722>
		 <5254B787.6080700@gmail.com> <1381284056.23937.49.camel@joe-AO722>
	 <5254BDD0.7040001@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 13:22 +1100, Ryan Mallon wrote:

> Anyway, updated patch below:

nit:

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1312,11 +1313,36 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  				spec.field_width = default_width;
>  			return string(buf, end, "pK-error", spec);
>  		}
> -		if (!((kptr_restrict == 0) ||
> -		      (kptr_restrict == 1 &&
> -		       has_capability_noaudit(current, CAP_SYSLOG))))
> +
> +		switch (kptr_restrict) {
> +		case 0:
> +			/* Always print %pK values */
> +			break;
> +		case 1: {
> +			/*
> +			 * Only print the real pointer value if the current
> +			 * proccess has CAP_SYSLOG and is running with the

s/proccess/process/ typo


