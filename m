Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab3EBSB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:01:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58851 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab3EBSB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:01:28 -0400
Date: Thu, 02 May 2013 14:01:25 -0400 (EDT)
Message-Id: <20130502.140125.697030413654996310.davem@davemloft.net>
To: bjorn@mork.no
Cc: kaber@trash.net, torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhutchings@solarflare.com
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <87d2t9bvj1.fsf@nemi.mork.no>
References: <20130502.041625.412316202038784117.davem@davemloft.net>
	<20130502083619.GA22010@macbook.localnet>
	<87d2t9bvj1.fsf@nemi.mork.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 May 2013 11:01:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Thu, 02 May 2013 11:06:42 +0200

> From d957cf339bf625869c39d852ac6733ef597ecef9 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
> Date: Thu, 2 May 2013 10:37:05 +0200
> Subject: [PATCH] net: vlan,ethtool: netdev_features_t is more than 32 bit
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Also applied and queued up for -stable.

These changes show me that this special type isn't providing type
safety in the way that we actually need it.

Something like how we do the MM page table types would work better:

typedef struct { u64 val; } netdev_features_t;

#define __netdev_feature(X)	((netdev_features_t) { X } )

and also with the appropriate set of accessors.

Then you can't get it wrong without a compile error.

But this is net-next material of course.
