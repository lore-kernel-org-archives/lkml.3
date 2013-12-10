Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3LJJ7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:59:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab3LJJ7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:59:42 -0500
Date: Tue, 10 Dec 2013 10:59:37 +0100
From: Michal Kubecek <mkubecek@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH v2 04/16] wl1251: implement hardware ARP filtering
Message-ID: <20131210095937.GC9741@unicorn.suse.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-5-git-send-email-pali.rohar@gmail.com>
 <20131210092916.GD22756@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210092916.GD22756@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 10:29:16AM +0100, Pavel Machek wrote:
> >  
> > +int wl1251_acx_arp_ip_filter(struct wl1251 *wl, bool enable, __be32 address)
> > +{
> > +	struct wl1251_acx_arp_filter *acx;
> > +	int ret;
> 
> Is it good idea to use be32 for IP address? AFAICT IPv4 addresses
> really don't have edianity. Perhaps u32 is better?

If they are known to be in network byte ordering, they do (as NBO is the
same as BE).

                                                         Michal Kubecek

