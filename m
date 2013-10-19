Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3JSBFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 21:05:54 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:47467 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751213Ab3JSBFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 21:05:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3870:3871:4321:4605:5007:6117:7514:7652:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12555:12740:13018:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: horn34_6d387305c822a
X-Filterd-Recvd-Size: 2132
Message-ID: <1382144748.2041.16.camel@joe-AO722>
Subject: Re: [PATCH] rtlwifi: rtl8192se: Fix wrong assignment
From: Joe Perches <joe@perches.com>
To: Felipe Pena <felipensp@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Oct 2013 18:05:48 -0700
In-Reply-To: <1382143960-4594-1-git-send-email-felipensp@gmail.com>
References: <1382143960-4594-1-git-send-email-felipensp@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 21:52 -0300, Felipe Pena wrote:
> There is a typo in the struct member name on assignment when checking
> rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40, the check uses pwrgroup_ht40
> for bound limit and uses pwrgroup_ht20 when assigning instead.
> 
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>  drivers/net/wireless/rtlwifi/rtl8192se/rf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
> index 5061f1d..92d38ab 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
> @@ -265,7 +265,7 @@ static void _rtl92s_get_txpower_writeval_byregulatory(struct ieee80211_hw *hw,
>  				    rtlefuse->pwrgroup_ht40
>  				    [RF90_PATH_A][chnl - 1]) {
>  					pwrdiff_limit[i] =
> -					  rtlefuse->pwrgroup_ht20
> +					  rtlefuse->pwrgroup_ht40
>  					  [RF90_PATH_A][chnl - 1];
>  				}

Using min could help minimize typos

					pwrdiff_limit[i] = min(pwrdiff_limit[i],
							       rtlefuse->pwrgroup_ht40[RF90_PATH_A][chnl - 1]);




