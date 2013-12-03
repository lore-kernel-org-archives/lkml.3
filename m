Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3LCQAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:00:25 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44864 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab3LCQAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:00:18 -0500
Date: Tue, 3 Dec 2013 10:52:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-ID: <20131203155245.GA2893@tuxdriver.com>
References: <20131203112032.b6c5faa3e40442b66770df91@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203112032.b6c5faa3e40442b66770df91@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:20:32AM +1100, Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless-next tree got a conflict in
> net/mac80211/util.c between commit 3f718fd8401d ("mac80211: fix the mesh
> channel switch support") from the wireless tree and commit ca91dc97b8a0
> ("mac80211: use put_unaligned_le16 for precedence value in mesh") from
> the wireless-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc net/mac80211/util.c
> index 9f9b9bd3fd44,06265d7f8cc3..000000000000
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@@ -2457,9 -2481,13 +2479,8 @@@ int ieee80211_send_action_csa(struct ie
>   			  WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT : 0x00;
>   		put_unaligned_le16(WLAN_REASON_MESH_CHAN, pos); /* Reason Cd */
>   		pos += 2;
> - 		pre_value = cpu_to_le16(ifmsh->pre_value);
> - 		memcpy(pos, &pre_value, 2);		/* Precedence Value */
>  -		if (!ifmsh->pre_value)
>  -			ifmsh->pre_value = 1;
>  -		else
>  -			ifmsh->pre_value++;
> + 		put_unaligned_le16(ifmsh->pre_value, pos);/* Precedence Value */
>   		pos += 2;
>  -		ifmsh->chsw_init = true;
>   	}
>   
>   	ieee80211_tx_skb(sdata, skb);

This differs from how I resolved the conflict when merging in wireless-testing...

Johannes, could you comment on which (if either) of these options is correct?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
