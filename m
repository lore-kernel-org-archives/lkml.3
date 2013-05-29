Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966190Ab3E2NtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:49:02 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33853 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966088Ab3E2NtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:49:00 -0400
Message-ID: <1369835337.5109.24.camel@edumazet-glaptop>
Subject: RE: [PATCH v6 net-next 2/5] net: implement support for low latency
 socket polling
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
Date: Wed, 29 May 2013 06:48:57 -0700
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7257@saturn3.aculab.com>
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>
	 <20130529063935.27486.18610.stgit@ladj378.jer.intel.com>
	 <1369834647.5109.15.camel@edumazet-glaptop>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7257@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 14:42 +0100, David Laight wrote:
> > > +/* we don't mind a ~2.5% imprecision */
> > > +#define TSC_MHZ (tsc_khz >> 10)
> 
> Wouldn't (tsc_khz << 10) be better?

We want number of cycles per usec.

Your formula gives number of cycles per 1.024 second.


