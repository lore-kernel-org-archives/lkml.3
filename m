Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaLPXWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:22:31 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64326 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaLPXWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:22:30 -0500
Message-ID: <1418772147.9773.67.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: net: integer overflow in ip_idents_reserve
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dave Jones <davej@redhat.com>
Date: Tue, 16 Dec 2014 15:22:27 -0800
In-Reply-To: <1418771356.3449499.203748285.4B1A82B8@webmail.messagingengine.com>
References: <5490A1F8.6020207@oracle.com>
	 <1418766460.9773.48.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1418771356.3449499.203748285.4B1A82B8@webmail.messagingengine.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 00:09 +0100, Hannes Frederic Sowa wrote:


> Also we compile the whole kernel with -fno-strict-overflow, so every
> report of signed overflow leading to undefined behavior is probably a
> false positive. I don't know if it is worth to try to get rid of them, I
> doubt it.

Presumably we could have uatomic_t , or atomic_u32_t, whatever...

This particular xadd() is heavily hit in some cases, we really do not
want a cmpxchg()



