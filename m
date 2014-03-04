Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaCDRNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:13:44 -0500
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:34971 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753521AbaCDRNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:13:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:560:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2198:2199:2200:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:4552:5007:7514:7652:7903:8957:10004:10400:10471:10848:11232:11658:11914:12296:12517:12519:12740:13069:13095:13161:13229:13255:13311:13357:13548,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cloud11_2013dbe16c229
X-Filterd-Recvd-Size: 2330
Message-ID: <1393953218.20435.34.camel@joe-AO722>
Subject: Re: Subject: [PATCH v2 1/1] Add documentation for proper usage and
 order of preference of calls to print diagnostic messages.
From: Joe Perches <joe@perches.com>
To: yogesh <mr.yogesh@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Levente Kurusa <levex@linux.com>,
        rdunlap@infradead.org
Date: Tue, 04 Mar 2014 09:13:38 -0800
In-Reply-To: <20140304170153.GA11780@yogesh-Dell-System-XPS-L502X>
References: <20140304170153.GA11780@yogesh-Dell-System-XPS-L502X>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 22:31 +0530, yogesh wrote:
> This patch adds documentation that clarifies the use of various
> diagnostic printing messages. It shows the preference of subsystem_dbg
> calls to dev_dbg (whenever possible), as the first preferred format of
> logging debug messages.
> Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>

Just two small things for next time, not enough
for a resend, but please add a blank line between
the commit log and the Signed-off line

commit message lines wrapped at around 70 columns
and another line...

Signed-off-by: Your Name <email@address.tld>

and...

> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
[]
> @@ -662,6 +662,23 @@ and driver, and are tagged with the right level:  dev_err(), dev_warn(),

> +Depending on your changes, the following order of precedence
> +applies to printing messages:
> +1. [subsystem]_dbg() is preferred when the subsystem has its own
> +diagnostic macros.
> +2. dev_dbg() is preferred when you have a generic struct device object.
> +3. pr_debug() should be used when 1 and 2 above are not applicable.
> +4. printk() should be avoided.

Another of my preferences would be to indent wrapped
lines when using numbered or bulleted lists.

1. [subsystem]_dbg is preferred when the subsystem has its own
   diagnostic macros or functions.
2. dev_dbg is ...
3. pr_debug ...
4. printk() ...


