Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146Ab3E2Nnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:43:51 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:38520 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965895Ab3E2Nns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:43:48 -0400
Message-ID: <1369835025.5109.21.camel@edumazet-glaptop>
Subject: RE: [PATCH v6 net-next 1/5] net: add napi_id and hash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 29 May 2013 06:43:45 -0700
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7256@saturn3.aculab.com>
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>
	 <20130529063925.27486.46649.stgit@ladj378.jer.intel.com>
	 <1369832201.5109.8.camel@edumazet-glaptop>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7256@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 14:09 +0100, David Laight wrote:
> > > Adds a napi_id and a hashing mechanism to lookup a napi by id.
> 
> Is this one of the places where the 'id' can be selected
> so that the 'hash' lookup never collides?

Very few devices will ever call napi_hash_add()

[ Real NIC RX queues, not virtual devices ]

We use a hash table with 256 slots, the chance of collision is about 0%

Lets not over engineer the thing before its even used.


