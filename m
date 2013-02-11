Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab3BKTSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:18:06 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:38417 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758164Ab3BKTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:18:04 -0500
X-Greylist: delayed 1022 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2013 14:18:04 EST
From: Florian Weimer <fw@deneb.enyo.de>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: memcmp_nta: add timing-attack secure memcmp
References: <cover.1360528614.git.dborkman@redhat.com>
	<e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com>
Date: Mon, 11 Feb 2013 20:00:54 +0100
In-Reply-To: <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com>
	(Daniel Borkmann's message of "Sun, 10 Feb 2013 23:00:07 +0100")
Message-ID: <87zjzallp5.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Borkmann:

> + * memcmp_nta - memcmp that is secure against timing attacks

It's not providing an ordering, so it should not have "cmp" in the
name.

> +	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
> +		res |= (*su1 ^ *su2);

The compiler could still short-circuit this loop.  Unlikely at
present, but this looks like a maintenance hazard.
