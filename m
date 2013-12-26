Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3LZInj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 03:43:39 -0500
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:49847 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751381Ab3LZInh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 03:43:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:4321:4605:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12533:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ear03_3c7e06b8c592d
X-Filterd-Recvd-Size: 1683
Message-ID: <1388047414.2459.4.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Date: Thu, 26 Dec 2013 00:43:34 -0800
In-Reply-To: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
References: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-25 at 21:37 +0900, Tetsuo Handa wrote:
> This patch introduces %pTC format specifier for reading task_struct->comm
> and %pT0 %pT1 %pT2 format specifiers for reading task_struct->comm and
> task_struct->pid.
[]
>   pr_info("comm=%s\n", p->comm);                => pr_info("comm=%pTC\n", p);
>   pr_info("%s[%u]\n", p->comm, p->pid);         => pr_info("%pT0\n", p);
>   pr_info("%s[%u]\n", p->comm, task_pid_nr(p)); => pr_info("%pT0\n", p);
>   pr_info("%s/%u\n", p->comm, p->pid);          => pr_info("%pT1\n", p);
>   pr_info("%s,%u\n", p->comm, p->pid);          => pr_info("%pT2\n", p);

Perhaps the presentation form should be standardized as well,
so %pT[012] would be unnecessary.'

Perhaps using only %pt and %ptp to emit the pid if desired
would be better.


