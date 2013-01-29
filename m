Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3A2SiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:38:24 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:32179
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143Ab3A2SiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:38:21 -0500
X-IronPort-AV: E=Sophos;i="4.84,561,1355094000"; 
   d="scan'208";a="408804"
Date: Tue, 29 Jan 2013 19:38:19 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Joe Perches <joe@perches.com>
cc: Valdis.Kletnieks@vt.edu, cocci@systeme.lip6.fr,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: coccinelle and bitmask arithmetic (was: Re: [patch] TTY: synclink,
 small cleanup in dtr_rts())
In-Reply-To: <1359475998.4196.26.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1301291937250.3339@hadrien>
References: <20130127194039.GA18787@elgon.mountain>  <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda>  <9561.1359474916@turing-police.cc.vt.edu> <1359475998.4196.26.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following rule looks promising:

@r@
constant c;
identifier i;
expression e;
@@

(
e | c@i
|
e & c@i
|
e |= c@i
|
e &= c@i
)

@@
constant r.c,c1;
identifier i1;
expression e;
@@

*c1@i1 + c

That is, the sum of two constants where at least one of them has been used
with & or |.

julia
