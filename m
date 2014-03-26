Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaCZWTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 18:19:20 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:48345 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbaCZWTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 18:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <1395871015.12610.254.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>
	<1395869625-15209-3-git-send-email-Julia.Lawall@lip6.fr>
	<1395871015.12610.254.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Wed, 26 Mar 2014 15:19:16 -0700
Message-ID: <CAGK4HS-4Lom2=CNR=tiX59xdorENPJdZMVncw10xiOOqZAkBwA@mail.gmail.com>
Subject: Re: [PATCH 2/7] atm: replace del_timer by del_timer_sync
From: Vijay Subramanian <subramanian.vijay@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        "David S. Miller" <davem@davemloft.net>,
        kernel-janitors@vger.kernel.org, tglx@linutronix.de,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> It seems this timer rearms itself, so this patch wont be enough I fear.
>
>
>
Does that matter? It seems del_timer_sync() may be intended to work
despite this (i.e. timer will not fire after call to this function).
My earlier attempt to fix a similar issue in sch_red.c resulted in
this explanation.
http://www.spinics.net/lists/netdev/msg256410.html

Vijay
