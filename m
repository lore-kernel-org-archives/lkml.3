Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3KLPoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:44:04 -0500
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:51447 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755925Ab3KLPoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:44:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2559:2562:2692:2828:2894:3138:3139:3140:3141:3142:3352:3622:3653:3865:3867:3868:3870:3873:3874:4321:4605:5007:7652:9149:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12555:12679:12740:13069:13141:13230:13311:13357:13848,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: horn53_5ad86a93782e
X-Filterd-Recvd-Size: 2447
Message-ID: <1384271045.4771.47.camel@joe-AO722>
Subject: Re: scripts: checkpatch.pl & Lindent (minor complaint)
From: Joe Perches <joe@perches.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 07:44:05 -0800
In-Reply-To: <1384267377.5754.25.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1384267377.5754.25.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 09:42 -0500, Mimi Zohar wrote: 
> scripts/Lindent and scripts/checkpatch disagree whether the fields in a
> statically initialized array should be blank separated.  
> 
> static struct ima_rule_entry default_rules[] = {
>         {.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
> 
> Lindent adds a blank before '.fsmagic', which checkpatch then complains
> about (eg. commit 75834fc3).

Perhaps I don't understand what you mean.

Lindent _doesn't_add a blank and checkpatch
seems to do the right thing here.

I'd just as soon delete Lindent.

$ git log --format=email -p -1 75834fc3 | ./scripts/checkpatch.pl -
WARNING: line over 80 characters
#35: FILE: security/integrity/ima/ima_policy.c:52:
+	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},

ERROR: space required after that ',' (ctx:VxV)
#35: FILE: security/integrity/ima/ima_policy.c:52:
+	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
 	                       ^
[...]

$ ./scripts/Lindent security/integrity/ima/ima_policy.c 
$ git diff security/integrity/ima/ima_policy.c | ./scripts/checkpatch.pl -
ERROR: space required after that ',' (ctx:VxV)
#10: FILE: security/integrity/ima/ima_policy.c:72:
+	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags =
 	                       ^

ERROR: space required after that ',' (ctx:VxV)
#10: FILE: security/integrity/ima/ima_policy.c:72:
+	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags =
 	                                                   ^
[...]


