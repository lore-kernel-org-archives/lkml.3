Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3LKVZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:25:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:30258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3LKVZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:25:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,873,1378882800"; 
   d="scan'208";a="448566600"
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Christian Grothoff <grothoff@in.tum.de>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, knock@gnunet.org, jacob@appelbaum.net
Subject: Re: [PATCH] TCP: add option for silent port knocking with integrity protection
References: <52A75EF8.3010308@in.tum.de>
	<20131211.150137.368953964178408437.davem@davemloft.net>
	<52A8C8B4.4060109@in.tum.de>
	<20131211122637.75b09074@nehalam.linuxnetplumber.net>
Date: Wed, 11 Dec 2013 13:25:22 -0800
In-Reply-To: <20131211122637.75b09074@nehalam.linuxnetplumber.net> (Stephen
	Hemminger's message of "Wed, 11 Dec 2013 12:26:37 -0800")
Message-ID: <87bo0nulkt.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> writes:
>
> The point is that doing it outside of TCP core is safer, less error prone
> and more flexible.

Or to put the question differently: what hooks would be needed to make
this efficiently work in user space?

It could be something like this: Firewall the port with forwarding the 
SYN packets using nfqueue, check for the SYN having the right magic,
change a firewall rule, re-inject using nfqueue (not fully sure how
well that works)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
