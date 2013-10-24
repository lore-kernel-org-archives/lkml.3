Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3JXHay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:30:54 -0400
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:42305 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752712Ab3JXHax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:30:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,3,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:4321:4605:5007:7652:7903:10012:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:2:0
X-HE-Tag: wash90_7be0bf114e734
X-Filterd-Recvd-Size: 1767
Message-ID: <1382599849.22433.51.camel@joe-AO722>
Subject: Re: [PATCH] scripts/checkkconfig.py: find unused Kconfig parameters
From: Joe Perches <joe@perches.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: mmarek@suse.cz, yann.morin.1998@free.fr, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Thu, 24 Oct 2013 00:30:49 -0700
In-Reply-To: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 07:23 +0200, Michael Opdenacker wrote:
> This is the first version of a script to look for
> Kconfig parameters which are still defined but no longer
> used in the kernel source code.
[]
> diff --git a/scripts/checkkconfig.py b/scripts/checkkconfig.py
[]
> +def count_param(param):
> +
> +    global source_file, bad_params_in_file
> +
> +    if os.path.isdir('.git'):
> +       # Use git grep when available
> +       count = subprocess.check_output('git grep ' + param + '| grep -v defconfig | wc -l', shell=True)
> +    else:
> +       # Fallback to regular grep
> +       count = subprocess.check_output('grep -R ' + param + ' . | grep -v defconfig | wc -l', shell=True)

Doesn't the grep need -w?

Also, the regular grep could probably use something like
'grep -R -w --max-count=2 --include="*.[chS]"'

