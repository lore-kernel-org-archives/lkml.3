Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3HUNxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:53:25 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60525 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3HUNxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:53:23 -0400
Message-ID: <1377093188.4226.108.camel@edumazet-glaptop>
Subject: Re: [PATCH RFC net-next] net: epoll support for busy poll
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Eilon Greenstein <eilong@broadcom.com>,
        Amir Vadai <amirv@mellanox.com>, Willem de Bruijn <willemb@google.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 21 Aug 2013 06:53:08 -0700
In-Reply-To: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com>
References: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-21 at 13:39 +0300, Eliezer Tamir wrote:

> 
> Instead of remembering the napi_id for all the sockets in an epoll,
> we only track the first socket we see with any unique napi_id.
> The rational for this is that while there may be many thousands of
> sockets tracked by a single epoll, we expect to only see a handful
> of unique napi_ids in most cases.

This looks buggy assumption to me.

We use epoll() with in the order of millions of fds per epoller, and
typically one napi_id per cpu.

With your model, we would have to use nr_cpu epollers and make sure that
sockets are properly placed on those epollers by their napi_ids.



