Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbbALQEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:04:31 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35103 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbbALQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:04:30 -0500
Message-ID: <1421078666.4099.6.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 2/3] x_tables: Use also dev->ifalias for interface
 matching
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: davem@davemloft.net, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bhutchings@solarflare.com,
        john.fastabend@gmail.com, herbert@gondor.apana.org.au,
        vyasevic@redhat.com, jiri@resnulli.us, vfalico@gmail.com,
        therbert@google.com, edumazet@google.com, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, kuznet@ms2.inr.ac.ru, kadlec@blackhole.kfki.hu,
        kaber@trash.net, pablo@netfilter.org, kay@vrfy.org,
        stephen@networkplumber.org
Date: Mon, 12 Jan 2015 08:04:26 -0800
In-Reply-To: <1421009571-5279-3-git-send-email-richard@nod.at>
References: <1421009571-5279-1-git-send-email-richard@nod.at>
	 <1421009571-5279-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-11 at 21:52 +0100, Richard Weinberger wrote:
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  include/linux/netfilter/x_tables.h | 22 ++++++++++++++++++++++
>  net/ipv4/netfilter/arp_tables.c    | 28 +++++++++++++++++-----------
>  net/ipv4/netfilter/ip_tables.c     | 15 +++++----------
>  net/ipv6/netfilter/ip6_tables.c    | 18 +++++++-----------
>  net/netfilter/xt_physdev.c         |  9 ++-------
>  5 files changed, 53 insertions(+), 39 deletions(-)

Richard, I dislike this, sorry.

iptables is already horribly expensive, you add another expensive step
for every rule.

device aliasing can be done from user space.

iptables should have used ifindex, its sad we allowed the substring
match in first place.


