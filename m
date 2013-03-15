Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3COMsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:48:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34329 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754263Ab3COMsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:48:50 -0400
Message-ID: <1363351729.2433.4.camel@joe-AO722>
Subject: Re: [PATCH] phy: Elimination the forced speed reduction algorithm.
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: kapranoff@inbox.ru, netdev@vger.kernel.org, bhutchings@solarflare.com,
        peppe.cavallaro@st.com, bruce.w.allan@intel.com,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Mar 2013 05:48:49 -0700
In-Reply-To: <20130315.083524.1244515166306242265.davem@davemloft.net>
References: <1363257652-8255-1-git-send-email-kapranoff@inbox.ru>
	 <20130315.083524.1244515166306242265.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 08:35 -0400, David Miller wrote:
> From: Kirill Kapranov <kapranoff@inbox.ru>
> Date: Thu, 14 Mar 2013 14:40:52 +0400
> 
> > @@ -867,7 +821,6 @@ void phy_state_machine(struct work_struct *work)
> >                               netif_carrier_on(phydev->attached_dev);
> >                       } else {
> >                               if (0 == phydev->link_timeout--) {
> > -                                     phy_force_reduction(phydev);
> >                                       needs_aneg = 1;
> >                               }
> 
> This is not a single-statement basic block, and therefore you
> should remove the surrounding braces.

s/not/now/

The phy code also uses non standard kernel style tests like
	if (CONSTANT == variable)
instead of
	if (variable == CONSTANT)


