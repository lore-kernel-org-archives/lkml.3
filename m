Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaKGTDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:03:32 -0500
Received: from smtprelay0224.hostedemail.com ([216.40.44.224]:60589 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751459AbaKGTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:03:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:305:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:6261:7903:8957:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13095:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pull55_14066440c720
X-Filterd-Recvd-Size: 2526
Message-ID: <1415387007.23530.16.camel@perches.com>
Subject: Re: [PATCH v3 3.18-rc3] kdb: Avoid printing KERN_ levels to consoles
From: Joe Perches <joe@perches.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, stable@vger.kernel.org
Date: Fri, 07 Nov 2014 11:03:27 -0800
In-Reply-To: <1415386070-18850-1-git-send-email-daniel.thompson@linaro.org>
References: <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>
	 <1415386070-18850-1-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 18:47 +0000, Daniel Thompson wrote:
> Currently when kdb traps printk messages then the raw log level prefix
> (consisting of '\001' followed by a numeral) does not get stripped off
> before the message is issued to the various I/O handlers supported by
> kdb. This causes annoying visual noise as well as causing problems
> grepping for ^. It is also a change of behaviour compared to normal usage
> of printk() usage. For example <SysRq>-h ends up with different output to
> that of kdb's "sr h".
> 
> This patch addresses the problem by stripping log levels from messages
> before they are issued to the I/O handlers. printk() which can also
> act as an i/o handler in some cases is special cased; if the caller
> provided a log level then the prefix will be preserved when sent to
> printk().
> 
> The addition of non-printable characters to the output of kdb commands is a
> regression, albeit and extremely elderly one, introduced by commit
> 04d2c8c83d0e ("printk: convert the format for KERN_<LEVEL> to a 2 byte
> pattern"). Note also that this patch does *not* restore the original
> behaviour from v3.5. Instead it makes printk() from within a kdb command
> display the message without any prefix (i.e. like printk() normally does).

This looks nicer.  Thanks Daniel.

