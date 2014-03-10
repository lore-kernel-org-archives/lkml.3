Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaCJW4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:56:04 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:54991 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaCJW4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:56:02 -0400
Date: Mon, 10 Mar 2014 23:56:00 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Florian Westphal <fwestpha@redhat.com>
Subject: Re: [PATCHv2 2/2] bridge: multicast: enable snooping on general queries only
Message-ID: <20140310225600.GJ5493@order.stressinduktion.org>
Mail-Followup-To: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>,
	netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
	Florian Westphal <fwestpha@redhat.com>
References: <1394486725-4992-1-git-send-email-linus.luessing@web.de> <1394486725-4992-2-git-send-email-linus.luessing@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394486725-4992-2-git-send-email-linus.luessing@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:25:25PM +0100, Linus Lüssing wrote:
>  	br_multicast_query_received(br, port, &br->ip6_querier,
> -				    !ipv6_addr_any(&ip6h->saddr), max_delay);
> +				    !ipv6_addr_any(&ip6h->saddr),
> +				    is_general_query, max_delay);

Just a small nit, maybe for a later patch:

After your change 6565b9eeef194a ("bridge: multicast: add sanity check
for query source addresses"), which is still in -net only, we could
replace !ipv6_addr_any(&ip6h->saddr) with '1'?

Greetings,

  Hannes

