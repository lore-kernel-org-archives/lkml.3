Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaEFT5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:57:09 -0400
Received: from one.firstfloor.org ([193.170.194.197]:57876 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaEFT5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:57:06 -0400
Date: Tue, 6 May 2014 21:57:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tom Herbert <therbert@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        josh@joshtriplett.org, David Miller <davem@davemloft.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506195704.GA5619@two.firstfloor.org>
References: <1399328773-6531-9-git-send-email-andi@firstfloor.org>
 <20140505.231229.136734008603421707.davem@davemloft.net>
 <20140506032114.GP2382@two.firstfloor.org>
 <20140505.232327.578134514220748085.davem@davemloft.net>
 <20140506155703.GA20391@cloud>
 <1399394359.15399.20.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140506183216.GM19657@tassilo.jf.intel.com>
 <CA+mtBx81EdtZeXRG_ubgWMy+8rSOpK3q0S3YktBDDFt-LG2poA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+mtBx81EdtZeXRG_ubgWMy+8rSOpK3q0S3YktBDDFt-LG2poA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can this at least be done without the combinatorial explosion in
> number of configurations? As Yuchung pointed out these patches
> introduce at least one unresolved configuration dependency. CONFIG_SMP
> works quite well since with a single parameter we can enable/disable a
> whole bunch of functionality in bulk, and it's quite clear that new
> development cannot break smp or non-smp configurations. Maybe you want
> something similar like CONFIG_NETWORK_SMALL?

Yes I've considered this.  I'm not sure SMP is good enough though,
at some point we'll get tiny dual core systems.

>From the 0/0:

>>>
Right now I'm using own Kconfigs for every removed features. I realize
this somewhat increases the compile test matrix. It would be possible
to hide some of the options and select them using higher level
configurations like the ones listed above. I haven't done this
in this version.
<<<

-Andi
