Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180Ab3K1RgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:36:23 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45008 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3K1RgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:36:22 -0500
Message-ID: <1385660180.5352.26.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] udp: fix possible seqlock deadlock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: jongman.heo@samsung.com
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Thu, 28 Nov 2013 09:36:20 -0800
In-Reply-To: <1385659390.5352.20.camel@edumazet-glaptop2.roam.corp.google.com>
References: <13025162.118881385612276530.JavaMail.weblogic@epv6ml01>
	 <1385659390.5352.20.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-28 at 09:23 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> In commit c9e9042994d3 ("ipv4: fix possible seqlock deadlock") I left
> another spot where IP_INC_STATS_BH() was improperly used.
> 
> udp_sendmsg() is called from process context, not from softirq context.
> 
> This was detected by lockdep seqlock support.
> 
> Reported-by: jongman heo <jongman.heo@samsung.com>
> Fixes: 584bdf8cbdf6 ("[IPV4]: Fix "ipOutNoRoutes" counter error for TCP and UDP")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> ---

Scrap this, I'll send a v2 with a complete check.


