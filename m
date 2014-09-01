Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaIAIus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:50:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:63439 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbaIAIud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:50:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,441,1406617200"; 
   d="scan'208";a="584476600"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Luis Henriques <luis.henriques@canonical.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH 3.11 005/137] iwlwifi: dvm: don't enable CTS to self
Thread-Topic: [PATCH 3.11 005/137] iwlwifi: dvm: don't enable CTS to self
Thread-Index: AQHPuseB6g8+Jto6MEGWBl5OYNwFlpvqsZewgAEo34CAADNYIA==
Date: Mon, 1 Sep 2014 08:50:28 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B27B314@hasmsx107.ger.corp.intel.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
 <1408354398-10226-6-git-send-email-luis.henriques@canonical.com>
 <0BA3FCBA62E2DC44AF3030971E174FB31B277EB2@hasmsx107.ger.corp.intel.com>
 <20140901084601.GA6903@hercules>
In-Reply-To: <20140901084601.GA6903@hercules>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Sun, Aug 31, 2014 at 12:04:19PM +0000, Grumbach, Emmanuel wrote:
> > > -----Original Message-----
> > > From: Luis Henriques [mailto:luis.henriques@canonical.com]
> > > Sent: Monday, August 18, 2014 12:31 PM
> > > To: linux-kernel@vger.kernel.org; stable@vger.kernel.org; kernel-
> > > team@lists.ubuntu.com
> > > Cc: Grumbach, Emmanuel; Luis Henriques
> > > Subject: [PATCH 3.11 005/137] iwlwifi: dvm: don't enable CTS to self
> > >
> > > 3.11.10.15 -stable review patch.  If anyone has any objections,
> > > please let me know.
> >
> > Just came back from a long travel - please drop this one. It has caused
> trouble to people.
> > I need to revert it.
> >
> 
> Thank you for your feedback, Emmanuel.
> 
> Unfortunately, this kernel has been released already and no more updates
> are foreseen to the 3.11 extended kernel -- this was its last release.
> 

Ok -  I just pushed the revert to my tree and sent a pull request.

> Cheers,
> --
> Luís
> 
> > >
> > > ------------------
> > >
> > > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > >
> > > commit 43d826ca5979927131685cc2092c7ce862cb91cd upstream.
> > >
> > > We should always prefer to use full RTS protection. Using CTS to
> > > self gives a meaningless improvement, but this flow is much harder
> > > for the firmware which is likely to have issues with it.
> > >
> > > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> > > ---
> > >  drivers/net/wireless/iwlwifi/dvm/rxon.c | 12 ------------
> > >  1 file changed, 12 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c
> > > b/drivers/net/wireless/iwlwifi/dvm/rxon.c
> > > index cd1ad0019185..ca17e4c9eca2 100644
> > > --- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
> > > +++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
> > > @@ -1072,13 +1072,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv,
> > > struct iwl_rxon_context *ctx)
> > >  	/* recalculate basic rates */
> > >  	iwl_calc_basic_rates(priv, ctx);
> > >
> > > -	/*
> > > -	 * force CTS-to-self frames protection if RTS-CTS is not preferred
> > > -	 * one aggregation protection method
> > > -	 */
> > > -	if (!priv->hw_params.use_rts_for_aggregation)
> > > -		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
> > > -
> > >  	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
> > >  	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
> > >  		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK; @@ -
> > > 1484,11 +1477,6 @@ void iwlagn_bss_info_changed(struct ieee80211_hw
> > > *hw,
> > >  	else
> > >  		ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
> > >
> > > -	if (bss_conf->use_cts_prot)
> > > -		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
> > > -	else
> > > -		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
> > > -
> > >  	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
> > >
> > >  	if (vif->type == NL80211_IFTYPE_AP ||
> > > --
> > > 1.9.1
> >
