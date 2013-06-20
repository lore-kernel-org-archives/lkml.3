Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3FTIOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:14:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65060 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab3FTIOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:14:07 -0400
Message-ID: <1371716040.3252.389.camel@edumazet-glaptop>
Subject: Re: [PATCH] net bridge: add null pointer check, fix panic
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xiaoming gao <gxm.linux.kernel@gmail.com>
Cc: stephen@networkplumber.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Jun 2013 01:14:00 -0700
In-Reply-To: <51C2B3A9.5070904@gmail.com>
References: <51C2710D.2060405@gmail.com> <51C2721B.9050603@gmail.com>
	  <1371704129.3252.356.camel@edumazet-glaptop> <51C2A8AA.5010902@gmail.com>
	 <1371713342.3252.371.camel@edumazet-glaptop> <51C2B3A9.5070904@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 15:47 +0800, xiaoming gao wrote:

> 
> if you remove the test on FF_BRIDGE_PORT, and br_port_get_rcu never returns NULL, the problem is fixed.
> but the codes in mainline is still bugged, am i right??
> by the way, kernel-stable 3.0 and 3.4 tree also have this bug, and is very easily to reproduce.

Commit 00cfec37484761a4 has to be backported anyway, if not already
backported.

I would rather fix things properly, instead of adding defensive code.


