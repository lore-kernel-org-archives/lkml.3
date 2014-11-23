Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaKWU1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 15:27:33 -0500
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:60828 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751818AbaKWU1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 15:27:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2861:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3653:3865:3866:3868:3870:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6261:7550:7903:8599:9025:9388:10004:10400:10848:11232:11658:11914:12043:12292:12517:12519:12679:12682:12740:13069:13311:13357:13845:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cart17_417dee2b76e11
X-Filterd-Recvd-Size: 1433
Message-ID: <1416774446.6651.56.camel@perches.com>
Subject: Re: [PATCH 1/1] scripts: add a graph generator based on checkpatch
 reports
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 23 Nov 2014 12:27:26 -0800
In-Reply-To: <1416689800-27146-1-git-send-email-fabf@skynet.be>
References: <1416689800-27146-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-22 at 21:56 +0100, Fabian Frederick wrote:
> This script generates a graph based on errors/warnings/checks detected
> by checkpatch -f recursively on each files of a directory.
> Results are grouped by subfolders and pushed in gnuplot datasets.

Why is this useful?

Ingo's badly named script does something similar:
http://people.redhat.com/mingo/x86.git/code-quality

just without the plots.

btw:  this line:

$files = `find $statdir -name "*.c"`;

should probably be

$files = `git ls-files -- "$statdir/*.[ch]"`;

