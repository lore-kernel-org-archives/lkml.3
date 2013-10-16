Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761022Ab3JPQtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:49:40 -0400
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:50851 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759389Ab3JPQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:49:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2892:3138:3139:3140:3141:3142:3167:3308:3353:3622:3865:3868:3872:3873:4321:5007:7652:7903:9165:10004:10400:10848:11232:11658:11914:12219:12517:12519:12555:12679:12740:13069:13141:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crate31_19a2502c18c56
X-Filterd-Recvd-Size: 2745
Message-ID: <1381942175.22110.57.camel@joe-AO722>
Subject: Re: [PATCH v2 0/9] Extended H/W error log driver
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, tony.luck@intel.com,
        naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Oct 2013 09:49:35 -0700
In-Reply-To: <20131016160550.GG13608@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
	 <20131016160550.GG13608@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 18:05 +0200, Borislav Petkov wrote:
> On Wed, Oct 16, 2013 at 10:55:57AM -0400, Chen, Gong wrote:
[]
> > After applying this patch series, when a memory corrected error happens,
> > we can get following information:
> > 
> > dmesg output:
> > 
> > [  949.545817] {1}Hardware error detected on CPU15
> > [  949.549786] {1}event severity: corrected
> > [  949.549786] {1} Error 0, type: corrected
> > [  949.549786] {1}  section_type: memory error
> > [  949.549786] {1}  physical_address: 0x0000001057eb0000
> > [  949.549786] {1}  DIMM location: Memriser3 CHANNEL A DIMM 0
> > [  949.549786] {1}Above error has been corrected by h/w and require no further action
> > [  949.549786] mce: [Hardware Error]: Machine check events logged

> Yep, looks almost very good. One nit: can you raise the action line
> higher, like this:
> 
> > [  949.545817] {1}Hardware error detected on CPU15
> > [  949.549786] {1}It has been corrected by h/w and requires no further action
> 
> <here come the error details>

Perhaps this would be nicer still with the "mce:" prefix
on all the log lines with the overall description emitted
first.  It could help make grepping the log a bit easier.

[  xxx.xxxxxx] mce: [Hardware Error]: Machine check events logged
[  xxx.xxxxxx] mce: {1}Hardware error detected on CPU15
[  xxx.xxxxxx] mce: {1}Above error has been corrected by h/w and require no further action
[  xxx.xxxxxx] mce: {1}event severity: corrected
[  xxx.xxxxxx] mce: {1} Error 0, type: corrected
[  xxx.xxxxxx] mce: {1}  section_type: memory error
[  xxx.xxxxxx] mce: {1}  physical_address: 0x0000001057eb0000
[  xxx.xxxxxx] mce: {1}  DIMM location: Memriser3 CHANNEL A DIMM 0

grammar: s/require/requires or maybe required


