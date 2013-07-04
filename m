Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab3GDVct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:32:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50912 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab3GDVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:32:48 -0400
Date: Thu, 04 Jul 2013 14:32:46 -0700 (PDT)
Message-Id: <20130704.143246.1946946036139459725.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: Ian.Campbell@citrix.com, joe.jin@oracle.com, alex@alex.org.uk,
        frank.blaschka@de.ibm.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, zheng.x.li@oracle.com, xen-devel@lists.xen.org,
        JBeulich@suse.com, stefano.stabellini@eu.citrix.com,
        konrad.wilk@oracle.com
Subject: Re: kernel panic in skb_copy_bits
From: David Miller <davem@davemloft.net>
In-Reply-To: <1372932730.4979.96.camel@edumazet-glaptop>
References: <1372930465.4979.82.camel@edumazet-glaptop>
	<1372931565.7184.32.camel@kazak.uk.xensource.com>
	<1372932730.4979.96.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 04 Jul 2013 03:12:10 -0700

> It looks like a typical COW issue to me.

Generically speaking, if we have to mess with page protections this
eliminates the performance gain from bypass/zerocopy/whatever that
these virtualization layers are doing.

But there may be other factors involved which might mitigate that.
