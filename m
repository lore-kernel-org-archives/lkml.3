Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaFXTn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:43:59 -0400
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:48758 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753942AbaFXTn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:43:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3870:3871:3873:4321:5007:6120:7652:9140:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crowd70_49835eed4c56
X-Filterd-Recvd-Size: 1801
Message-ID: <1403639030.29061.37.camel@joe-AO725>
Subject: Re: [RFC PATCH 1/3] init.h: Add __init_str / __exit_str macros
From: Joe Perches <joe@perches.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Date: Tue, 24 Jun 2014 12:43:50 -0700
In-Reply-To: <1403477209-14612-2-git-send-email-minipli@googlemail.com>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	 <1403477209-14612-2-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 00:46 +0200, Mathias Krause wrote:
> Add macros to be able to mark string literals used in __init / __exit
> functions.
[]
> diff --git a/include/linux/init.h b/include/linux/init.h
[]
> +#define __init_str(str)	__mark_str(str, __UNIQUE_ID(_init_str_), __initconst)
> +#define __exit_str(str)	__mark_str(str, __UNIQUE_ID(_exit_str_), __exitdata)
> +#define __mark_str(str, var, __section) \
> +	({ static const char var[] __section __aligned(1) = str; var; })
> +

You probably want to make these strings vanish
completely when !CONFIG_PRINTK.

As is, they will always exist in the image.


