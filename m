Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaAIU00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:26:26 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:59997 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbaAIU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:26:18 -0500
MIME-Version: 1.0
In-Reply-To: <20140109201642.28381.82141.stgit@viggo.jf.intel.com>
References: <20140109201157.28381.94057.stgit@viggo.jf.intel.com>
	<20140109201642.28381.82141.stgit@viggo.jf.intel.com>
Date: Thu, 9 Jan 2014 15:26:17 -0500
Message-ID: <CADVnQy=Tk68y217cbw7O5apCJV+eOmKMqLNbgAZRa_cxUArdKg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] net: make tcp_cleanup_rbuf private
From: Neal Cardwell <ncardwell@google.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Netdev <netdev@vger.kernel.org>, James Morris <jmorris@namei.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Patrick McHardy <kaber@trash.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 3:16 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> net_dma was the only external user so this can become local to tcp.c
> again.
...
> -void tcp_cleanup_rbuf(struct sock *sk, int copied)
> +static void cleanup_rbuf(struct sock *sk, int copied)

I would vote to keep the tcp_ prefix. In the TCP code base that is the
more common idiom, even for internal/static TCP functions, and
personally I find it easier to read and work with in stack traces,
etc. My 2 cents.

neal
