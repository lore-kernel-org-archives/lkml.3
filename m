Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaBJAxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:53:50 -0500
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:37197 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751907AbaBJAxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:53:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3866:3868:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chalk63_5b2e1eec80a4a
X-Filterd-Recvd-Size: 1316
Message-ID: <1391993624.3178.11.camel@joe-AO722>
Subject: Re: [PATCH 2/5] ncpfs: Convert DPRINTK/DDPRINTK to ncp_dbg
From: Joe Perches <joe@perches.com>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 16:53:44 -0800
In-Reply-To: <29642e506f8f78fd1308326c1c7c2e0a8a0be056.1391985629.git.joe@perches.com>
References: <cover.1391985629.git.joe@perches.com>
	 <29642e506f8f78fd1308326c1c7c2e0a8a0be056.1391985629.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 14:48 -0800, Joe Perches wrote:
> Use a more current logging style and enable use of dynamic debugging.
[]
> diff --git a/fs/ncpfs/ncp_fs.h b/fs/ncpfs/ncp_fs.h
[]
> +#define ncp_dbg(level, fmt, ...)				\
> +do {								\
> +	if (level >= DEBUG_NCP)					\
> +		pr_debug(fmt, ##__VA_ARGS__);			\
> +} while (0)

Stupid thinko/typo self-nack.  This should be:

	if (DEBUG_NCP >= level)


