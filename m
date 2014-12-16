Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaLPXJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:09:20 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56634 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbaLPXJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:09:18 -0500
Message-Id: <1418771356.3449499.203748285.4B1A82B8@webmail.messagingengine.com>
X-Sasl-Enc: Q5LOdyRWFvxXa++bgj3bo2J0d7HfMnMoE2mmENVaQ9Qt 1418771356
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dave Jones <davej@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-e9370556
Subject: Re: net: integer overflow in ip_idents_reserve
Date: Wed, 17 Dec 2014 00:09:16 +0100
In-Reply-To: <1418766460.9773.48.camel@edumazet-glaptop2.roam.corp.google.com>
References: <5490A1F8.6020207@oracle.com>
 <1418766460.9773.48.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, Dec 16, 2014, at 22:47, Eric Dumazet wrote:
> On Tue, 2014-12-16 at 16:19 -0500, Sasha Levin wrote:
> > Hi Eric,
> > 
> > While fuzzing with trinity on a -next kernel with the undefined behaviour
> > sanitizer path, I've observed the following warning in code which was
> > introduced in 04ca6973f7 ("ip: make IP identifiers less predictable"):
> 
> This is a false positive.

Also we compile the whole kernel with -fno-strict-overflow, so every
report of signed overflow leading to undefined behavior is probably a
false positive. I don't know if it is worth to try to get rid of them, I
doubt it.

Bye,
Hannes
