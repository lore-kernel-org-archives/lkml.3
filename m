Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3LPWmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 17:42:16 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:48394 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LPWmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 17:42:14 -0500
Message-ID: <1387233731.19078.254.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] [RFC] udp: ipv4: fix potential deadlock on sk_dst_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Eric Dumazet <edumazet@google.com>, Shawn Bohrer <sbohrer@rgmadvisors.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 16 Dec 2013 14:42:11 -0800
In-Reply-To: <alpine.LNX.2.00.1312162336220.12882@pobox.suse.cz>
References: <alpine.LNX.2.00.1312162336220.12882@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 23:37 +0100, Jiri Kosina wrote:
> Commit 975022310 ("udp: ipv4: must add synchronization in 
> udp_sk_rx_dst_set()) caused sk_dst_lock to be obtained in udp4 receive 
> path, which is happening in softirq context.
> 
> inet_bind() is taking sk_dst_lock (through sk_dst_reset()) without turning 
> IRQs off, which results in the lockdep splat below.
> 
> Fix that by disabling IRQs while taking the lock in sk_dst_reset().



Thanks but I posted this fix instead :

 http://patchwork.ozlabs.org/patch/301382/




