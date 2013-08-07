Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457Ab3HGXsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:48:19 -0400
Received: from server506e.appriver.com ([50.56.144.35]:55737 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932784Ab3HGXsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:48:18 -0400
X-Note-AR-ScanTimeLocal: 8/7/2013 6:48:17 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-58/SG:2 8/7/2013 6:47:35 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.97926 Source White
X-Signature-Violations: 0-0-0-2623-c
X-Note-419: 0 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/7/2013 6:48:17 PM
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G319 G320 G321 G322 G326 G327 G434 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: VALID
X-Note: Headers Injected
Subject: Re: [PATCH] aoe: adjust ref of head for compound page tails
MIME-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <3F0FBDD9-129C-45F4-A20C-3EB2E8EFC9C8@coraid.com>
Date: Wed, 7 Aug 2013 19:48:15 -0400
CC: <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        <linux-mm@kvack.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <B5AF5A8D-2849-4027-A524-BA31BBCF8C8F@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com> <0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com> <20130807135804.e62b75f6986e9568ab787562@linux-foundation.org> <8DFEA276-4EE1-44B4-9669-5634631D7BBC@coraid.com> <20130807141835.533816143f8b37175c50d58d@linux-foundation.org> <20130807142755.5cd89e02e4286f7dca88b80d@linux-foundation.org> <3F0FBDD9-129C-45F4-A20C-3EB2E8EFC9C8@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2013, at 7:41 PM, Ed Cashin wrote:

> It sounds like it's wrong to give block pages with a zero count, so why not just have aoe BUG_ON(compound_trans_head(bv->page->_count) == 0) until we're sure nobody does that anymore?

Ugh.  I goofed the parens and such.  I meant,

  BUG_ON(compound_trans_head(bv->bv_page)->_count == 0)

... will catch the cases we think should not be occurring.

> If that idea makes sense to you, I will submit a new patch to follow the one under discussion.

-- 
  Ed Cashin
  ecashin@coraid.com


