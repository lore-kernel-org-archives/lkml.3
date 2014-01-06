Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaAFJGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:06:05 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:41916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaAFJGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:06:00 -0500
Message-ID: <1388999147.5891.2.camel@jlt4.sipsolutions.net>
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
Date: Mon, 06 Jan 2014 10:05:47 +0100
In-Reply-To: <alpine.DEB.2.10.1312311732080.2074@hadrien>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-31 at 17:40 +0100, Julia Lawall wrote:

> > If nothing else, then some run-time code that calculates the offset off
> > and asserts if it is broken in module initialization or similar might
> > be good enough.
> 
> Could be OK.  Something right in or after the structure declaration would
> be nicest.

I don't think you can put a BUILD_BUG_ON() into the structure
declaration (it's code, not declarations), but I think you could just
put

BUILD_BUG_ON(sizeof(struct foo) - offsetof(struct foo, addr) < 8);

with the user(s?) and that should catch the scenario I was worrying
about?

johannes


