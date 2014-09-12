Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaILUrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:47:17 -0400
Received: from smtprelay0015.hostedemail.com ([216.40.44.15]:52244 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751411AbaILUrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:47:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3872:3876:4321:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cord60_790680434d736
X-Filterd-Recvd-Size: 1442
Message-ID: <1410554830.9942.52.camel@joe-AO725>
Subject: Re: [Keyrings] [PATCH 1/9] Provide a binary to hex conversion
 function
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, vgoyal@redhat.com,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 13:47:10 -0700
In-Reply-To: <28503.1410553800@warthog.procyon.org.uk>
References: <1410552676.5187.211.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <20140912190510.13239.90409.stgit@warthog.procyon.org.uk>
	 <20140912190515.13239.89507.stgit@warthog.procyon.org.uk>
	 <28503.1410553800@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 21:30 +0100, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > How about using hex_byte_pack()?
> It doesn't do a bufferful, only one byte.

I think Mimi meant using something like:

char *bin2hex(char *dst, const void *src, size_t count)
{
	const unsigned char *_src = src;

	while (count--)
		dst = hex_byte_pack(dst, *_src++);

	return dst;
}


