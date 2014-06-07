Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaFGApq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 20:45:46 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:37286 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaFGApo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 20:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140606231921.2ff39106ac54216fd9170fae@qrator.net>
References: <20140606231921.2ff39106ac54216fd9170fae@qrator.net>
Date: Fri, 6 Jun 2014 17:45:44 -0700
Message-ID: <CAHA+R7NUVPz47AKCTk7nYBkZXK=93vJOO8f6FTkyU0UkU6Q30Q@mail.gmail.com>
Subject: Re: [PATCH] ipip, sit: fix ipv4_{update_pmtu,redirect} calls
From: Cong Wang <cwang@twopensource.com>
To: Dmitry Popov <ixaphire@qrator.net>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        trivial@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 12:19 PM, Dmitry Popov <ixaphire@qrator.net> wrote:
> ipv4_{update_pmtu,redirect} were called with tunnel's ifindex (t->dev is a
> tunnel netdevice). It caused wrong route lookup and failure of pmtu update or
> redirect. We should use the same ifindex that we use in ip_route_output_* in
> *tunnel_xmit code. It is t->parms.link .
>
> Signed-off-by: Dmitry Popov <ixaphire@qrator.net>
> ---
>  net/ipv4/ipip.c | 4 ++--
>  net/ipv6/sit.c  | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

I think vti (v4 and v6) tunnel needs to fix as well?
