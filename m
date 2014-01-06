Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaAFKSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:18:14 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:42173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaAFKSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:18:12 -0500
Message-ID: <1389003467.5891.5.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
From: Johannes Berg <johannes@sipsolutions.net>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Ben Greear <greearb@candelatech.com>, Joe Perches <joe@perches.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 11:17:47 +0100
In-Reply-To: <alpine.DEB.2.10.1401061007160.2079@hadrien>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
	   <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>
	   <1388429761.4410.1.camel@jlt4.sipsolutions.net>
	   <alpine.DEB.2.02.1312302057420.2209@localhost6.localdomain6>
	   <1388438724.4573.2.camel@jlt4.sipsolutions.net>
	   <20131230215701.GA4938@khazad-dum.debian.net>
	   <1388445188.18164.0.camel@jlt4.sipsolutions.net>
	  <1388445422.26796.38.camel@joe-AO722>
	  <alpine.DEB.2.02.1312310726540.1930@localhost6.localdomain6>
	  <52C2E8BA.6000800@candelatech.com>
	  <alpine.DEB.2.10.1312311704320.2074@hadrien>
	  <52C2F056.1020005@candelatech.com>
	  <alpine.DEB.2.10.1312311732080.2074@hadrien>
	 <1388999147.5891.2.camel@jlt4.sipsolutions.net>
	 <alpine.DEB.2.10.1401061007160.2079@hadrien>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 10:09 +0100, Julia Lawall wrote:

> > BUILD_BUG_ON(sizeof(struct foo) - offsetof(struct foo, addr) < 8);
> >
> > with the user(s?) and that should catch the scenario I was worrying
> > about?
> 
> OK, thanks.  That is what I had in mind.  But I was hoping to be able to
> put it with the structure.  

Right - you might be able to do that with BUILD_BUG_ON_ZERO() as you
pointed out, I haven't looked at these macros in a while.

> Perhaps there is a way to make a macro that
> expands to a dummy function that contains the BUILD_BUG_ON?  But I guess
> that would waste space?
> 
> I think that 8 should be 16?

No, that should be ETH_ALEN+2 really, I guess - it's not taking into
account the size of the address member itself at all.

johannes


