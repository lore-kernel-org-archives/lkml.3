Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236Ab3E1NiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:38:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36504 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061Ab3E1NiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:38:03 -0400
Message-ID: <1369748280.3301.534.camel@edumazet-glaptop>
Subject: Re: [PATCH v5 net-next 1/5] net: add napi_id and hash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 28 May 2013 06:38:00 -0700
In-Reply-To: <51A464B9.5080106@linux.intel.com>
References: <20130527074351.29882.51106.stgit@ladj378.jer.intel.com>
	  <20130527074401.29882.98135.stgit@ladj378.jer.intel.com>
	 <1369700905.3301.499.camel@edumazet-glaptop>
	 <51A464B9.5080106@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 11:03 +0300, Eliezer Tamir wrote:

> With an atomic we don't need the RTNL in any of the napi_id functions.
> One less thing to worry about when we try to remove the RTNL.

OK but we'll need something to protect the lists against concurrent
insert/deletes.

A spinlock or a mutex.



