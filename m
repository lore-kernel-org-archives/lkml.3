Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab3HGVMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:12:45 -0400
Received: from server506b.appriver.com ([50.56.144.14]:51367 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933227Ab3HGVMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:12:40 -0400
X-Note-AR-ScanTimeLocal: 8/7/2013 4:12:38 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-82/SG:2 8/7/2013 4:12:37 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.977602 Source White
X-Signature-Violations: 0-0-0-4229-c
X-Note-419: 15.6008 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/7/2013 4:12:19 PM
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
In-Reply-To: <20130807135804.e62b75f6986e9568ab787562@linux-foundation.org>
Date: Wed, 7 Aug 2013 17:12:36 -0400
CC: <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <8DFEA276-4EE1-44B4-9669-5634631D7BBC@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com> <0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com> <20130807135804.e62b75f6986e9568ab787562@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2013, at 4:58 PM, Andrew Morton wrote:

> On Thu, 1 Aug 2013 21:29:59 -0400 Ed Cashin <ecashin@coraid.com> wrote:
> 
>> As discussed previously,
> 
> I think I missed that.
> 
>> the fact that some users of the block
>> layer provide bios that point to pages with a zero _count means
>> that it is not OK for the network layer to do a put_page on the
>> skb frags during an skb_linearize, so the aoe driver gets a
>> reference to pages in bios and puts the reference before ending
>> the bio.  And because it cannot use get_page on a page with a
>> zero _count, it manipulates the value directly.
> 
> Eh?  What code is putting count==0 pages into bios?  That sounds very
> weird and broken.

I thought so in 2007 but couldn't solicit a clear "this is wrong" consensus from the discussion.

  http://article.gmane.org/gmane.linux.kernel/499197
  https://lkml.org/lkml/2007/1/19/56
  https://lkml.org/lkml/2006/12/18/230

We were seeing zero-count pages in bios from XFS, but Christoph Hellwig pointed out that kmalloced pages can also come from ext3 when it's doing log recovery, and they'll have zero page counts.

I don't have a counter in the driver to track how often zero-count pages show up in bios, so I don't know how common it is these days.  I would have been motivated to look if I had gotten the impression that there was any interest in identifying and eliminating cases where zero-count pages were being used in bios.

-- 
  Ed Cashin
  ecashin@coraid.com


