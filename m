Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3KYE0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 23:26:39 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:34204 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3KYE0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 23:26:35 -0500
Date: Mon, 25 Nov 2013 05:26:33 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Shawn Landden <shawn@churchofgit.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: [PATCH] update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST
Message-ID: <20131125042633.GA4156@order.stressinduktion.org>
Mail-Followup-To: Shawn Landden <shawn@churchofgit.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tom Herbert <therbert@google.com>,
	"David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
References: <1385342706.10637.125.camel@edumazet-glaptop2.roam.corp.google.com> <1385345339-2184-1-git-send-email-shawn@churchofgit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385345339-2184-1-git-send-email-shawn@churchofgit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 06:08:59PM -0800, Shawn Landden wrote:
> Commit 35f9c09fe (tcp: tcp_sendpages() should call tcp_push() once)
> added an internal flag MSG_SENDPAGE_NOTLAST, similar to
> MSG_MORE.
> 
> algif_hash and algif_skcipher used MSG_MORE from tcp_sendpages()
> and need to see the new flag as identical to MSG_MORE.
> 
> This fixes sendfile() on AF_ALG.

Don't we need a similar fix for udp_sendpage?

Greetings,

  Hannes

