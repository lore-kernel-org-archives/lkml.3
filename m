Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161100AbaJaPPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:15:54 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:52393 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086AbaJaPPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:15:53 -0400
Message-ID: <1414768548.3014.34.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/2] cfg80211: 802.11p OCB mode handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Fri, 31 Oct 2014 16:15:48 +0100
In-Reply-To: <1414768360.8048.4.camel@umadbro> (sfid-20141031_161242_006101_8D0C70ED)
References: <1414665771-8371-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1414665771-8371-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20141030_114322_295525_C7C629F8) <1414761237.3014.27.camel@jlt4.sipsolutions.net>
	 <1414768360.8048.4.camel@umadbro> (sfid-20141031_161242_006101_8D0C70ED)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 16:12 +0100, Rostislav Lisovy wrote:
> On Fri, 2014-10-31 at 14:13 +0100, Johannes Berg wrote:
> > On Thu, 2014-10-30 at 11:42 +0100, Rostislav Lisovy wrote:
> > > @@ -2093,6 +2102,7 @@ enum nl80211_iftype {
> > >  	NL80211_IFTYPE_P2P_CLIENT,
> > >  	NL80211_IFTYPE_P2P_GO,
> > >  	NL80211_IFTYPE_P2P_DEVICE,
> > > +	NL80211_IFTYPE_OCB,
> > 
> > This is causing a bunch of compiler warnings (warning: enumeration value
> > ‘NL80211_IFTYPE_OCB’ not handled in switch, e.g. in mac80211/iface.c)
> > which I think you should address in this patch. That'll mean that you
> > modify even mac80211 and potentially some drivers, but I think that's
> > the right thing to do in this patch since it's the one changing the API
> > to introduce the new value.
> 
> I was aware of the warnings but thought this is the chicken-egg problem
> which can't be solved properly.
> Fortunately there is no driver affected.

Yeah I checked the drivers after sending the mail :)

I think you can add dummy "case OCB" statements to mac80211 in this
patch, and then overwrite them with proper code in the next one. I'd
like to have the build warning-free for every commit, if at all
possible.

johannes

