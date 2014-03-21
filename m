Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaCUSwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 14:52:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35004 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaCUSwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 14:52:32 -0400
Date: Fri, 21 Mar 2014 14:52:29 -0400 (EDT)
Message-Id: <20140321.145229.1026128975151125729.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: andi@firstfloor.org, hpa@zytor.com, kaber@trash.net,
        herbert@gondor.apana.org.au, hkchu@google.com, mwdalton@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] csum experts, csum_replace2() is too expensive
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395406250.9114.142.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1395341341.9114.93.camel@edumazet-glaptop2.roam.corp.google.com>
	<87a9cknwk4.fsf@tassilo.jf.intel.com>
	<1395406250.9114.142.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Mar 2014 11:52:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 21 Mar 2014 05:50:50 -0700

> It looks like a barrier() would be more appropriate.

barrier() == __asm__ __volatile__(:::"memory")
