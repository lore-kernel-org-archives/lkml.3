Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3CWX5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 19:57:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35437 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3CWX5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 19:57:41 -0400
Date: Sat, 23 Mar 2013 19:57:40 -0400 (EDT)
Message-Id: <20130323.195740.2108147521543354261.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, c.aeschlimann@acn-group.ch
Subject: Re: [PATCH] Fix IXP4xx coherent allocations
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3obe9lxil.fsf@intrepid.localdomain>
References: <m3obe9lxil.fsf@intrepid.localdomain>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 23 Mar 2013 16:57:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 23 Mar 2013 20:35:46 +0100

> ARM core code currently requires coherent DMA mask to be set. Make sure
> we limit PCI devices to 64 MiB while allowing on-chip devices to access
> the whole 4 GiB address space.
> 
> This fixes a v3.7+ regression which broke IXP4xx built-in network devices.
> 
> Signed-off-by: Krzysztof Ha©©asa <khc@pm.waw.pl>

This requirement is not reasonable.

The DMA API documentation clearly states what the default must be,
and what drivers are guarenteed will be the default.
