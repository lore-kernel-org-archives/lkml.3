Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3JAWqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:46:21 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:52500 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3JAWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:46:17 -0400
Date: Wed, 2 Oct 2013 00:45:15 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: "Ruslan N. Marchenko" <me@ruff.mobi>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Regression in 2fdac010
 drivers/net/ethernet/via/via-velocity.c: update napi implementation
Message-ID: <20131001224515.GA3113@electric-eye.fr.zoreil.com>
References: <20130930071531.GA13037@ruff.mobi>
 <alpine.DEB.2.02.1309301342530.2036@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309301342530.2036@localhost6.localdomain6>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia.lawall@lip6.fr> :
[...]
> There has already been a discussion about this, and a patch has already 
> been proposed.  It has to do with lock managament.  I will look for the 
> email.

The underlying problem has to do with disabled irq. netif_receive_skb
assumes irq to be enabled. Current via-velocity poll() method should
narrow its (spinlocked) irq disabled section.

What I've done should not require much analysis (aka "what could race
with the rx bh processing in a napi driver ?") and avoids a more intrusive
lockless napi design.

-- 
Ueimor
