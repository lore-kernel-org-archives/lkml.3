Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3BUPyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:54:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36529 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3BUPyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:54:09 -0500
MIME-Version: 1.0
Message-ID: <9e251fb2-be82-41d2-b6cd-e46525b263cb@default>
Date: Thu, 21 Feb 2013 07:50:06 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCHv6 0/8] zswap: compressed swap caching
References: <1361397888-14863-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1361397888-14863-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: [PATCHv6 0/8] zswap: compressed swap caching
> 
> Changelog:
> 
> v6:
> * fix improper freeing of rbtree (Cody)

Cody's bug fix reminded me of a rather fundamental question:

Why does zswap use a rbtree instead of a radix tree?

Intuitively, I'd expect that pgoff_t values would
have a relatively high level of locality AND at any one time
the set of stored pgoff_t values would be relatively non-sparse.
This would argue that a radix tree would result in fewer nodes
touched on average for lookup/insert/remove.

Do you have evidence that rbtree is better here?
(Preferably over a set of workloads larger than
kernbench and SPECjbb ;-)  Or are there other
important design issues that disqualify a radix tree?

In the end, I guess either one (rbtree or radix tree)
will work, but it would be nice to get this kind of
fundamental design issue properly solved before merging
is to be considered.

Dan
