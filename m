Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaCGR0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:26:35 -0500
Received: from mail.us.es ([193.147.175.20]:56111 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbaCGR0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:26:32 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus4 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18544. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-101.0/7.5):. 
 Processed in 2.418555 secs); 07 Mar 2014 17:26:31 -0000
X-Spam-ASN: AS29670 217.197.80.0/20
X-Envelope-From: pneira@us.es
Date: Fri, 7 Mar 2014 18:26:27 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: behanw@converseincode.com
Cc: davem@davemloft.net, kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>,
        =?iso-8859-1?Q?Vin=EDcius?= Tinti <viniciustinti@gmail.com>
Subject: Re: [PATCH] net: inetfilter: LLVMLinux: vlais-netfilter
Message-ID: <20140307172627.GA4856@localhost>
References: <1394135768-27621-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394135768-27621-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 11:56:08AM -0800, behanw@converseincode.com wrote:
> From: Mark Charlebois <charlebm@gmail.com>
> 
> Replaced non-standard C use of Variable Length Arrays In Structs (VLAIS) in
> xt_repldata.h with a C99 compliant flexible array member and then calculated
> offsets to the other struct members. These other members aren't referenced by
> name in this code, however this patch maintains the same memory layout and
> padding as was previously accomplished using VLAIS.
> 
> Had the original structure been ordered differently, with the entries VLA at
> the end, then it could have been a flexible member, and this patch would have
> been a lot simpler. However since the data stored in this structure is
> ultimately exported to userspace, the order of this structure can't be changed.
> 
> This patch makes no attempt to change the existing behavior, merely the way in
> which the current layout is accomplished using standard C99 constructs. As such
> the code can now be compiled with either gcc or clang.

I think we already agreed on not accepting macro tricks to get this
compiling with clang:

http://comments.gmane.org/gmane.comp.security.firewalls.netfilter.devel/45138
