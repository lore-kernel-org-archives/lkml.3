Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3LCQJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:09:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:43998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab3LCQJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:09:56 -0500
Message-ID: <1386086983.4393.38.camel@jlt4.sipsolutions.net>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 wireless tree
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        Bob Copeland <bob@cozybit.com>
Date: Tue, 03 Dec 2013 17:09:43 +0100
In-Reply-To: <20131203155245.GA2893@tuxdriver.com>
References: <20131203112032.b6c5faa3e40442b66770df91@canb.auug.org.au>
	 <20131203155245.GA2893@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 15:52 +0000, John W. Linville wrote:

> > Today's linux-next merge of the wireless-next tree got a conflict in
> > net/mac80211/util.c between commit 3f718fd8401d ("mac80211: fix the mesh
> > channel switch support") from the wireless tree and commit ca91dc97b8a0
> > ("mac80211: use put_unaligned_le16 for precedence value in mesh") from
> > the wireless-next tree.
> >
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> >
> > --
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> >
> > diff --cc net/mac80211/util.c
> > index 9f9b9bd3fd44,06265d7f8cc3..000000000000
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@@ -2457,9 -2481,13 +2479,8 @@@ int ieee80211_send_action_csa(struct ie
> >                         WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT : 0x00;
> >               put_unaligned_le16(WLAN_REASON_MESH_CHAN, pos); /* Reason Cd */
> >               pos += 2;
> > -             pre_value = cpu_to_le16(ifmsh->pre_value);
> > -             memcpy(pos, &pre_value, 2);             /* Precedence Value */
> >  -            if (!ifmsh->pre_value)
> >  -                    ifmsh->pre_value = 1;
> >  -            else
> >  -                    ifmsh->pre_value++;
> > +             put_unaligned_le16(ifmsh->pre_value, pos);/* Precedence Value */
> >               pos += 2;
> >  -            ifmsh->chsw_init = true;
> >       }
> >
> >       ieee80211_tx_skb(sdata, skb);
> 
> This differs from how I resolved the conflict when merging in wireless-testing...
> 
> Johannes, could you comment on which (if either) of these options is correct?

I think the above is correct, the pre_value assignment with 1/++ and
chsw_init moved into another function in Bob's patch. Bob?

johannes

