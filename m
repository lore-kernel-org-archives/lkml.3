Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaKFQNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:13:30 -0500
Received: from smtprelay0002.hostedemail.com ([216.40.44.2]:58894 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750963AbaKFQNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:13:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:305:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:3874:4321:5007:6119:6261:7903:8957:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: elbow15_3a7c33966e447
X-Filterd-Recvd-Size: 2073
Message-ID: <1415290399.6634.52.camel@perches.com>
Subject: Re: [RESEND PATCH 3.18-rc3] kdb: Avoid printing KERN_ levels to
 consoles
From: Joe Perches <joe@perches.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 06 Nov 2014 08:13:19 -0800
In-Reply-To: <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>
References: <1411555097-16924-1-git-send-email-daniel.thompson@linaro.org>
	 <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 15:27 +0000, Daniel Thompson wrote:
> Currently when kdb traps printk messages then the raw log level prefix
> (consisting of '\001' followed by a numeral) does not get stripped off
> before the message is issued to the various I/O handlers supported by
> kdb. This causes annoying visual noise as well as causing problems
> grepping for ^. It is also a change of behaviour compared to normal usage
> of printk() usage. For example <SysRq>-h ends up with different to that of
> kdb's "sr h".
> 
> This patch addresses the problem by stripping log levels from messages
> before they are issued to the I/O handlers.

Perhaps instead of stripping the logging level,
maybe a KERN_SOH_ASCII 'char' sequence should be
emitted as '<' 'char' '>' (see: printk:print_prefix)

Maybe this should be added to stable from v3.6
when KERN_SOH_ASCII was first added.


