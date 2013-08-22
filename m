Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3HVULh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:11:37 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:56698 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab3HVULg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:11:36 -0400
Date: Thu, 22 Aug 2013 20:11:35 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Eilon Greenstein <eilong@broadcom.com>,
        Amir Vadai <amirv@mellanox.com>, Eric Dumazet <erdnetdev@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH RFC net-next] net: epoll support for busy poll
Message-ID: <20130822201135.GA4088@dcvr.yhbt.net>
References: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliezer Tamir <eliezer.tamir@linux.intel.com> wrote:
> Performance:
> using sockperf, Intel X520 NICs,
> Supermicro 6026TT-BTF systems with E5-2690 Xeon CPUs
> 100 UDP sockets avg. latency 5.756 (std-dev 0.510)
> 1k  UDP sockets avg. latency 5.780 (std-dev 0.536)
> 10k UDP sockets avg. latency 6.269 (std-dev 0.611)

How does this compare to with normal poll on this system?

In other words, what advantage is there to using epoll instead of poll
when busy looping?

epoll and busy_poll seem to be opposites.  epoll inherently has higher
latency than normal poll, but provides stable performance with many more
FDs.
