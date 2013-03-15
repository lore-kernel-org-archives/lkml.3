Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3COMfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:35:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46715 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3COMfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:35:09 -0400
Date: Fri, 15 Mar 2013 08:35:24 -0400 (EDT)
Message-Id: <20130315.083524.1244515166306242265.davem@davemloft.net>
To: kapranoff@inbox.ru
Cc: netdev@vger.kernel.org, bhutchings@solarflare.com, peppe.cavallaro@st.com,
        joe@perches.com, bruce.w.allan@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: Elimination the forced speed reduction algorithm.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363257652-8255-1-git-send-email-kapranoff@inbox.ru>
References: <1363257652-8255-1-git-send-email-kapranoff@inbox.ru>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 15 Mar 2013 05:35:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Kapranov <kapranoff@inbox.ru>
Date: Thu, 14 Mar 2013 14:40:52 +0400

> @@ -867,7 +821,6 @@ void phy_state_machine(struct work_struct *work)
>  				netif_carrier_on(phydev->attached_dev);
>  			} else {
>  				if (0 == phydev->link_timeout--) {
> -					phy_force_reduction(phydev);
>  					needs_aneg = 1;
>  				}

This is not a single-statement basic block, and therefore you
should remove the surrounding braces.
