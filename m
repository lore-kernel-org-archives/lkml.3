Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3LCSQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:16:15 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33106 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3LCSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:16:13 -0500
Date: Tue, 3 Dec 2013 13:12:47 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        Bob Copeland <bob@cozybit.com>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-ID: <20131203181246.GD13712@localhost>
References: <20131203112032.b6c5faa3e40442b66770df91@canb.auug.org.au>
 <20131203155245.GA2893@tuxdriver.com>
 <1386086983.4393.38.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386086983.4393.38.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 05:09:43PM +0100, Johannes Berg wrote:
> > > diff --cc net/mac80211/util.c
> > > index 9f9b9bd3fd44,06265d7f8cc3..000000000000
> > > --- a/net/mac80211/util.c
> > > +++ b/net/mac80211/util.c
> > > @@@ -2457,9 -2481,13 +2479,8 @@@ int ieee80211_send_action_csa(struct ie
> > >                         WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT : 0x00;
> > >               put_unaligned_le16(WLAN_REASON_MESH_CHAN, pos); /* Reason Cd */
> > >               pos += 2;
> > > -             pre_value = cpu_to_le16(ifmsh->pre_value);
> > > -             memcpy(pos, &pre_value, 2);             /* Precedence Value */
> > >  -            if (!ifmsh->pre_value)
> > >  -                    ifmsh->pre_value = 1;
> > >  -            else
> > >  -                    ifmsh->pre_value++;
> > > +             put_unaligned_le16(ifmsh->pre_value, pos);/* Precedence Value */
> > >               pos += 2;
> > >  -            ifmsh->chsw_init = true;
> > >       }
> > >
> > >       ieee80211_tx_skb(sdata, skb);


> I think the above is correct, the pre_value assignment with 1/++ and
> chsw_init moved into another function in Bob's patch. Bob?

The quoted resolution looks right to me.  But, I think the patch
in question was actually Chun-yeow's so I'm not sure my opinion
counts :)

-- 
Bob Copeland %% www.bobcopeland.com
