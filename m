Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaAFJEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:04:51 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:7149 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbaAFJEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:04:48 -0500
X-IronPort-AV: E=Sophos;i="4.95,611,1384297200"; 
   d="scan'208";a="43650688"
Date: Mon, 6 Jan 2014 10:04:28 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Joe Perches <joe@perches.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Johannes Berg <johannes@sipsolutions.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
In-Reply-To: <1388998750.5808.43.camel@joe-AO722>
Message-ID: <alpine.DEB.2.10.1401061001340.2079@hadrien>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>  <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>  <1388429761.4410.1.camel@jlt4.sipsolutions.net>  <alpine.DEB.2.02.1312302057420.2209@localhost6.localdomain6> 
 <1388438724.4573.2.camel@jlt4.sipsolutions.net>  <20131230215701.GA4938@khazad-dum.debian.net>  <1388445188.18164.0.camel@jlt4.sipsolutions.net>  <1388445422.26796.38.camel@joe-AO722>  <alpine.DEB.2.10.1401060947550.2079@hadrien>
 <1388998750.5808.43.camel@joe-AO722>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jan 2014, Joe Perches wrote:

> On Mon, 2014-01-06 at 09:48 +0100, Julia Lawall wrote:
> > Is there any way to get sizeof evaluated at build time?
>
> I'm confused a bit by what you want to accomplish.

To check that a field that is an argument od ether_addr_equal_64bits is
a sufficient distance from the end of the structure.

> Except for variable length arrays, isn't sizeof always
> evaluated at build time?

OK, the question was expressed badly.  Is there any way to use the value
to trigger an action at build time?  The only way I kow to trigger an
action is with #error, but #error is processed by cpp, which doesn't know
about the size of types.

julia

> 6.5.3.4 The sizeof operator
> Constraints
> []
> 2 The sizeof operator yields the size (in bytes) of its operand, which may be an
> expression or the parenthesized name of a type. The size is determined from the type of
> the operand. The result is an integer. If the type of the operand is a variable length array
> type, the operand is evaluated; otherwise, the operand is not evaluated and the result is an
> integer constant.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
