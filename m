Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaJARpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:45:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaJARpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:45:11 -0400
Date: Wed, 01 Oct 2014 13:45:08 -0400 (EDT)
Message-Id: <20141001.134508.1301867654128829684.davem@davemloft.net>
To: hliang1025@gmail.com
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, adi-linux-docs@lists.sourceforge.net
Subject: Re: [PATCH] net: ethernet : stmicro: fixed power suspend and
 resume failure in stmmac driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAPig_t=oA6BuAt77DDsLqrtRBDbV_vsoAxM31XxLjkAFpYG1-Q@mail.gmail.com>
References: <1412056534-7995-1-git-send-email-hliang1025@gmail.com>
	<20140930.151056.950254777090461575.davem@davemloft.net>
	<CAPig_t=oA6BuAt77DDsLqrtRBDbV_vsoAxM31XxLjkAFpYG1-Q@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 10:45:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hao Liang <hliang1025@gmail.com>
Date: Wed, 1 Oct 2014 14:08:28 +0800

> I double-check my patch and the ->mac->xxx calls are still under the lock.
> I think that lock is trying to protect priv struct and related data, so i
> just remove some functions have no bearing on priv struct.

It's preventing parallel invocations of the ->mac->xxx calls.

The other instances are in device open/close, where RTNL semaphore is
held, and no other code paths in the driver can be active.

You need the lock.
