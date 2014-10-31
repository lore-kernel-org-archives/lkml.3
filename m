Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbaJaN3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:29:24 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:51881 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758302AbaJaN3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:29:23 -0400
Message-ID: <1414762158.3014.33.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: 802.11p OCB mode support
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Fri, 31 Oct 2014 14:29:18 +0100
In-Reply-To: <1414665771-8371-3-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20141030_114323_275977_11FDCB49)
References: <1414665771-8371-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1414665771-8371-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20141030_114323_275977_11FDCB49)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-30 at 11:42 +0100, Rostislav Lisovy wrote:

> +int ieee80211_ocb_join(struct ieee80211_sub_if_data *sdata,
> +		       struct ocb_setup *setup)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
> +	u32 changed = BSS_CHANGED_OCB;
> +	int err;
> +
> +	if (ifocb->joined == true)
> +		return -EINVAL;

You could, potentially, use the fact that you have a channel context
assigned instead. However, locking might make that awkward, and this is
perfectly fine as well of course. It's probably not worth changing it.

Looks good to me.

johannes

