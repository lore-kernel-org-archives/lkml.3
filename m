Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaFBRih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:38:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35161 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaFBRif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:38:35 -0400
Date: Mon, 02 Jun 2014 10:38:34 -0700 (PDT)
Message-Id: <20140602.103834.1994455666478487120.davem@davemloft.net>
To: emilgoode@gmail.com
Cc: Wei.Yang@windriver.com, peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] stmmac: Remove spin_lock call in
 stmmac_get_pauseparam()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401701450-1203-1-git-send-email-emilgoode@gmail.com>
References: <1401701450-1203-1-git-send-email-emilgoode@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 10:38:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Goode <emilgoode@gmail.com>
Date: Mon,  2 Jun 2014 11:30:50 +0200

> The following patch removed unnecessary spin_lock/unlock calls
> in ethtool_ops callback functions. In the second and final version
> of the patch one spin_lock call was left behind.
> 
> commit cab6715c3e8029e98b0b5d4056ceda007c0f6380
> Author: Yang Wei <Wei.Yang@windriver.com>
> Date:   Sun May 25 09:53:44 2014 +0800
> 
>     net: driver: stmicro: Remove some useless the lock protection
> 
> This introduced the following sparse warning:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c:424:1: warning:
> 	context imbalance in 'stmmac_get_pauseparam' -
> 	different lock contexts for basic block
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Good catch, applied, thanks Emil.
