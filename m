Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaE1XVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:21:32 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:64195 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaE1XVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:21:21 -0400
MIME-Version: 1.0
X-Originating-IP: [128.107.151.95]
In-Reply-To: <1401319048-15797-2-git-send-email-c@24.io>
References: <1401319048-15797-1-git-send-email-c@24.io>
	<1401319048-15797-2-git-send-email-c@24.io>
Date: Wed, 28 May 2014 16:21:19 -0700
Message-ID: <CADadk9EKDiRH171UuNRZnQ-54TfjNy1PiginN8SBnwsi_jxjKA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Staging: rtl8192u: r8192U_wx.c Code cleanup and
 code-style additions
From: Chaitanya Hazarey <c@24.io>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chaitanya Hazarey <c@24.io>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch, there seems something wrong with it, will
resend with a new subject.

Thanks,

Chaitanya

On Wed, May 28, 2014 at 4:17 PM, Chaitanya Hazarey <c@24.io> wrote:
> Removed dead code
> Deleted stray newlines
> Added newlines for better code readability
>
> Addressed the following errors:
>
> ERROR: do not use C99 // comments
> ERROR: need consistent spacing around '|' (ctx:VxW)
>
> Signed-off-by: Chaitanya Hazarey <c@24.io>
> ---
>  drivers/staging/rtl8192u/r8192U_wx.c | 155 +++++++++++++++++------------------
>  1 file changed, 76 insertions(+), 79 deletions(-)
>
> diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
> index 675a12d..ad9bc0b 100644
> --- a/drivers/staging/rtl8192u/r8192U_wx.c
> +++ b/drivers/staging/rtl8192u/r8192U_wx.c
> @@ -57,6 +57,7 @@ static int r8192_wx_get_rate(struct net_device *dev,
>                              union iwreq_data *wrqu, char *extra)
>  {
>         struct r8192_priv *priv = ieee80211_priv(dev);
> +
>         return ieee80211_wx_get_rate(priv->ieee80211, info, wrqu, extra);
>  }
>
> @@ -100,6 +101,7 @@ static int r8192_wx_get_rts(struct net_device *dev,
>                              union iwreq_data *wrqu, char *extra)
>  {
>         struct r8192_priv *priv = ieee80211_priv(dev);
> +
>         return ieee80211_wx_get_rts(priv->ieee80211, info, wrqu, extra);
>  }
>
> @@ -124,6 +126,7 @@ static int r8192_wx_get_power(struct net_device *dev,
>                              union iwreq_data *wrqu, char *extra)
>  {
>         struct r8192_priv *priv = ieee80211_priv(dev);
> +
>         return ieee80211_wx_get_power(priv->ieee80211, info, wrqu, extra);
>  }
>
> @@ -180,8 +183,8 @@ static int r8192_wx_set_crcmon(struct net_device *dev,
>               priv->crcmon ? "accepted" : "rejected");
>
>         if (prev != priv->crcmon && priv->up) {
> -               //rtl8180_down(dev);
> -               //rtl8180_up(dev);
> +               /*rtl8180_down(dev);
> +                 rtl8180_up(dev); */
>         }
>
>         up(&priv->wx_sem);
> @@ -194,6 +197,7 @@ static int r8192_wx_set_mode(struct net_device *dev, struct iw_request_info *a,
>  {
>         struct r8192_priv *priv = ieee80211_priv(dev);
>         int ret;
> +
>         down(&priv->wx_sem);
>
>         ret = ieee80211_wx_set_mode(priv->ieee80211, a, wrqu, b);
> @@ -249,15 +253,15 @@ static int rtl8180_wx_get_range(struct net_device *dev,
>         /* ~5 Mb/s real (802.11b) */
>         range->throughput = 5 * 1000 * 1000;
>
> -       // TODO: Not used in 802.11b?
> -//     range->min_nwid;        /* Minimal NWID we are able to set */
> -       // TODO: Not used in 802.11b?
> -//     range->max_nwid;        /* Maximal NWID we are able to set */
> +       /* TODO: Not used in 802.11b? */
> +       /*range->min_nwid; */   /* Minimal NWID we are able to set */
> +       /* TODO: Not used in 802.11b? */
> +       /*range->max_nwid; */   /* Maximal NWID we are able to set */
>
>         /* Old Frequency (backward compat - moved lower ) */
> -//     range->old_num_channels;
> -//     range->old_num_frequency;
> -//     range->old_freq[6]; /* Filler to keep "version" at the same offset */
> +       /*range->old_num_channels; */
> +       /*range->old_num_frequency; */
> +       /*range->old_freq[6]; */ /* Filler to keep "version" at the same offset */
>         if (priv->rf_set_sens != NULL)
>                 range->sensitivity = priv->max_sens;    /* signal level threshold range */
>
> @@ -292,26 +296,26 @@ static int rtl8180_wx_get_range(struct net_device *dev,
>         range->we_version_compiled = WIRELESS_EXT;
>         range->we_version_source = 16;
>
> -//     range->retry_capa;      /* What retry options are supported */
> -//     range->retry_flags;     /* How to decode max/min retry limit */
> -//     range->r_time_flags;    /* How to decode max/min retry life */
> -//     range->min_retry;       /* Minimal number of retries */
> -//     range->max_retry;       /* Maximal number of retries */
> -//     range->min_r_time;      /* Minimal retry lifetime */
> -//     range->max_r_time;      /* Maximal retry lifetime */
> +       /*range->retry_capa; */ /* What retry options are supported */
> +       /*range->retry_flags; */        /* How to decode max/min retry limit */
> +       /*range->r_time_flags; */       /* How to decode max/min retry life */
> +       /*range->min_retry; */  /* Minimal number of retries */
> +       /*range->max_retry; */  /* Maximal number of retries */
> +       /*range->min_r_time; */ /* Minimal retry lifetime */
> +       /*range->max_r_time; */ /* Maximal retry lifetime */
>
>
>         for (i = 0, val = 0; i < 14; i++) {
>
> -               // Include only legal frequencies for some countries
> +               /* Include only legal frequencies for some countries */
>                 if ((GET_DOT11D_INFO(priv->ieee80211)->channel_map)[i+1]) {
>                         range->freq[val].i = i + 1;
>                         range->freq[val].m = ieee80211_wlan_frequencies[i] * 100000;
>                         range->freq[val].e = 1;
>                         val++;
>                 } else {
> -                       // FIXME: do we need to set anything for channels
> -                       // we don't use ?
> +                       /* FIXME: do we need to set anything for channels
> +                          we don't use ? */
>                 }
>
>                 if (val == IW_MAX_FREQUENCIES)
> @@ -341,10 +345,8 @@ static int r8192_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
>         if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
>                 struct iw_scan_req *req = (struct iw_scan_req *)b;
>                 if (req->essid_len) {
> -                       //printk("==**&*&*&**===>scan set ssid:%s\n", req->essid);
>                         ieee->current_network.ssid_len = req->essid_len;
>                         memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
> -                       //printk("=====>network ssid:%s\n", ieee->current_network.ssid);
>                 }
>         }
>
> @@ -386,6 +388,7 @@ static int r8192_wx_set_essid(struct net_device *dev,
>  {
>         struct r8192_priv *priv = ieee80211_priv(dev);
>         int ret;
> +
>         down(&priv->wx_sem);
>
>         ret = ieee80211_wx_set_essid(priv->ieee80211, a, wrqu, b);
> @@ -434,6 +437,7 @@ static int r8192_wx_get_name(struct net_device *dev,
>                              union iwreq_data *wrqu, char *extra)
>  {
>         struct r8192_priv *priv = ieee80211_priv(dev);
> +
>         return ieee80211_wx_get_name(priv->ieee80211, info, wrqu, extra);
>  }
>
> @@ -480,7 +484,7 @@ static int r8192_wx_set_wap(struct net_device *dev,
>
>         int ret;
>         struct r8192_priv *priv = ieee80211_priv(dev);
> -//        struct sockaddr *temp = (struct sockaddr *)awrq;
> +
>         down(&priv->wx_sem);
>
>         ret = ieee80211_wx_set_wap(priv->ieee80211, info, awrq, extra);
> @@ -519,11 +523,9 @@ static int r8192_wx_set_enc(struct net_device *dev,
>         struct ieee80211_device *ieee = priv->ieee80211;
>         int ret;
>
> -       //u32 TargetContent;
>         u32 hwkey[4] = {0, 0, 0, 0};
>         u8 mask = 0xff;
>         u32 key_idx = 0;
> -       //u8 broadcast_addr[6] ={       0xff,0xff,0xff,0xff,0xff,0xff};
>         u8 zero_addr[4][6] = {  {0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
>                                 {0x00, 0x00, 0x00, 0x00, 0x00, 0x01},
>                                 {0x00, 0x00, 0x00, 0x00, 0x00, 0x02},
> @@ -542,7 +544,7 @@ static int r8192_wx_set_enc(struct net_device *dev,
>
>
>
> -       //sometimes, the length is zero while we do not type key value
> +       /* sometimes, the length is zero while we do not type key value */
>         if (wrqu->encoding.length != 0) {
>
>                 for (i = 0; i < 4; i++) {
> @@ -584,12 +586,12 @@ static int r8192_wx_set_enc(struct net_device *dev,
>                         EnableHWSecurityConfig8192(dev);
>
>                         setKey(dev,
> -                               key_idx,                //EntryNo
> -                               key_idx,                //KeyIndex
> -                               KEY_TYPE_WEP40,         //KeyType
> +                               key_idx,                /* EntryNo */
> +                               key_idx,                /* KeyIndex */
> +                               KEY_TYPE_WEP40,         /* KeyType */
>                                 zero_addr[key_idx],
> -                               0,                      //DefaultKey
> -                               hwkey);                 //KeyContent
> +                               0,                      /* DefaultKey */
> +                               hwkey);                 /* KeyContent */
>
>                 }
>
> @@ -598,12 +600,12 @@ static int r8192_wx_set_enc(struct net_device *dev,
>                                 EnableHWSecurityConfig8192(dev);
>
>                         setKey(dev,
> -                               key_idx,                //EntryNo
> -                               key_idx,                //KeyIndex
> -                               KEY_TYPE_WEP104,        //KeyType
> +                               key_idx,                /* EntryNo */
> +                               key_idx,                /* KeyIndex */
> +                               KEY_TYPE_WEP104,        /* KeyType */
>                                 zero_addr[key_idx],
> -                               0,                      //DefaultKey
> -                               hwkey);                 //KeyContent
> +                               0,                      /* DefaultKey */
> +                               hwkey);                 /* KeyContent */
>
>                 } else {
>                         printk("wrong type in WEP, not WEP40 and WEP104\n");
> @@ -703,7 +705,6 @@ static int r8192_wx_get_retry(struct net_device *dev,
>                 wrqu->retry.flags = IW_RETRY_LIMIT | IW_RETRY_MIN;
>                 wrqu->retry.value = priv->retry_data;
>         }
> -       //printk("returning %d",wrqu->retry.value);
>
>
>         return 0;
> @@ -714,6 +715,7 @@ static int r8192_wx_get_sens(struct net_device *dev,
>                                 union iwreq_data *wrqu, char *extra)
>  {
>         struct r8192_priv *priv = ieee80211_priv(dev);
> +
>         if (priv->rf_set_sens == NULL)
>                 return -1; /* we have not this support for this radio */
>         wrqu->sens.value = priv->sens;
> @@ -727,10 +729,9 @@ static int r8192_wx_set_sens(struct net_device *dev,
>  {
>
>         struct r8192_priv *priv = ieee80211_priv(dev);
> -
>         short err = 0;
> +
>         down(&priv->wx_sem);
> -       //DMESG("attempt to set sensivity to %ddb",wrqu->sens.value);
>         if (priv->rf_set_sens == NULL) {
>                 err = -1; /* we have not this support for this radio */
>                 goto exit;
> @@ -746,7 +747,7 @@ exit:
>         return err;
>  }
>
> -//hw security need to reorganized.
> +/* hw security need to reorganized. */
>  static int r8192_wx_set_enc_ext(struct net_device *dev,
>                                         struct iw_request_info *info,
>                                         union iwreq_data *wrqu, char *extra)
> @@ -754,8 +755,6 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
>         int ret = 0;
>         struct r8192_priv *priv = ieee80211_priv(dev);
>         struct ieee80211_device *ieee = priv->ieee80211;
> -       //printk("===>%s()\n", __func__);
> -
>
>         down(&priv->wx_sem);
>         ret = ieee80211_wx_set_encode_ext(priv->ieee80211, info, wrqu, extra);
> @@ -768,10 +767,10 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
>                 struct iw_point *encoding = &wrqu->encoding;
>                 u8 idx = 0, alg = 0, group = 0;
>                 if ((encoding->flags & IW_ENCODE_DISABLED) || ext->alg == IW_ENCODE_ALG_NONE)
> -                       //none is not allowed to use hwsec WB 2008.07.01
> +                       /* none is not allowed to use hwsec WB 2008.07.01 */
>                         goto end_hw_sec;
>
> -               // as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4;
> +               /* as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4; */
>                 alg =  (ext->alg == IW_ENCODE_ALG_CCMP)?KEY_TYPE_CCMP:ext->alg;
>                 idx = encoding->flags & IW_ENCODE_INDEX;
>                 if (idx)
> @@ -784,34 +783,34 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
>                         ieee->pairwise_key_type = alg;
>                         EnableHWSecurityConfig8192(dev);
>                 }
> -               memcpy((u8 *)key, ext->key, 16); //we only get 16 bytes key.why? WB 2008.7.1
> +               memcpy((u8 *)key, ext->key, 16); /* we only get 16 bytes key.why? WB 2008.7.1 */
>
>                 if ((alg & KEY_TYPE_WEP40) && (ieee->auth_mode != 2)) {
>
>                         setKey(dev,
> -                                       idx,//EntryNo
> -                                       idx, //KeyIndex
> -                                       alg,  //KeyType
> -                                       zero, //MacAddr
> -                                       0,              //DefaultKey
> -                                       key);           //KeyContent
> +                                       idx,/* EntryNo */
> +                                       idx, /* KeyIndex */
> +                                       alg,  /* KeyType */
> +                                       zero, /* MacAddr */
> +                                       0,              /* DefaultKey */
> +                                       key);           /* KeyContent */
>                 } else if (group) {
>                         ieee->group_key_type = alg;
>                         setKey(dev,
> -                                       idx,//EntryNo
> -                                       idx, //KeyIndex
> -                                       alg,  //KeyType
> -                                       broadcast_addr, //MacAddr
> -                                       0,              //DefaultKey
> -                                       key);           //KeyContent
> -               } else {//pairwise key
> +                                       idx,/* EntryNo */
> +                                       idx, /* KeyIndex */
> +                                       alg,  /* KeyType */
> +                                       broadcast_addr, /* MacAddr */
> +                                       0,              /* DefaultKey */
> +                                       key);           /* KeyContent */
> +               } else {/* pairwise key */
>                         setKey(dev,
> -                                       4,//EntryNo
> -                                       idx, //KeyIndex
> -                                       alg,  //KeyType
> -                                       (u8 *)ieee->ap_mac_addr, //MacAddr
> -                                       0,              //DefaultKey
> -                                       key);           //KeyContent
> +                                       4,/* EntryNo */
> +                                       idx, /* KeyIndex */
> +                                       alg,  /* KeyType */
> +                                       (u8 *)ieee->ap_mac_addr, /* MacAddr */
> +                                       0,              /* DefaultKey */
> +                                       key);           /* KeyContent */
>                 }
>
>
> @@ -828,8 +827,8 @@ static int r8192_wx_set_auth(struct net_device *dev,
>                                         union iwreq_data *data, char *extra)
>  {
>         int ret = 0;
> -       //printk("====>%s()\n", __func__);
>         struct r8192_priv *priv = ieee80211_priv(dev);
> +
>         down(&priv->wx_sem);
>         ret = ieee80211_wx_set_auth(priv->ieee80211, info, &(data->param), extra);
>         up(&priv->wx_sem);
> @@ -840,10 +839,9 @@ static int r8192_wx_set_mlme(struct net_device *dev,
>                                         struct iw_request_info *info,
>                                         union iwreq_data *wrqu, char *extra)
>  {
> -       //printk("====>%s()\n", __func__);
> -
>         int ret = 0;
>         struct r8192_priv *priv = ieee80211_priv(dev);
> +
>         down(&priv->wx_sem);
>         ret = ieee80211_wx_set_mlme(priv->ieee80211, info, wrqu, extra);
>
> @@ -855,13 +853,12 @@ static int r8192_wx_set_gen_ie(struct net_device *dev,
>                                         struct iw_request_info *info,
>                                         union iwreq_data *data, char *extra)
>  {
> -          //printk("====>%s(), len:%d\n", __func__, data->length);
>         int ret = 0;
>         struct r8192_priv *priv = ieee80211_priv(dev);
> +
>         down(&priv->wx_sem);
>         ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, data->data.length);
>         up(&priv->wx_sem);
> -       //printk("<======%s(), ret:%d\n", __func__, ret);
>         return ret;
>
>
> @@ -923,13 +920,13 @@ static iw_handler r8192_wx_handlers[] = {
>         r8192_wx_get_power,                    /* SIOCGIWPOWER */
>         NULL,                   /*---hole---*/
>         NULL,                   /*---hole---*/
> -       r8192_wx_set_gen_ie,//NULL,                     /* SIOCSIWGENIE */
> +       r8192_wx_set_gen_ie,/*NULL, */                  /* SIOCSIWGENIE */
>         NULL,                   /* SIOCSIWGENIE */
>
> -       r8192_wx_set_auth,//NULL,                       /* SIOCSIWAUTH */
> -       NULL,//r8192_wx_get_auth,//NULL,                        /* SIOCSIWAUTH */
> +       r8192_wx_set_auth,/*NULL, */                    /* SIOCSIWAUTH */
> +       NULL,/*r8192_wx_get_auth, NULL, */                      /* SIOCSIWAUTH */
>         r8192_wx_set_enc_ext,                   /* SIOCSIWENCODEEXT */
> -       NULL,//r8192_wx_get_enc_ext,//NULL,                     /* SIOCSIWENCODEEXT */
> +       NULL,/*r8192_wx_get_enc_ext, NULL, */                   /* SIOCSIWENCODEEXT */
>         NULL,                   /* SIOCSIWPMKSA */
>         NULL,                    /*---hole---*/
>
> @@ -962,14 +959,14 @@ static const struct iw_priv_args r8192_private_args[] = {
>
>
>  static iw_handler r8192_private_handler[] = {
> -//     r8192_wx_set_monitor,  /* SIOCIWFIRSTPRIV */
> +       /*r8192_wx_set_monitor, */  /* SIOCIWFIRSTPRIV */
>         r8192_wx_set_crcmon,   /*SIOCIWSECONDPRIV*/
> -//     r8192_wx_set_forceassociate,
> -//     r8192_wx_set_beaconinterval,
> -//     r8192_wx_set_monitor_type,
> +       /*r8192_wx_set_forceassociate, */
> +       /*r8192_wx_set_beaconinterval, */
> +       /*r8192_wx_set_monitor_type, */
>         r8192_wx_set_scan_type,
>         r8192_wx_set_rawtx,
> -       //r8192_wx_null,
> +       /*r8192_wx_null, */
>         r8192_wx_force_reset,
>  };
>
> @@ -981,6 +978,7 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
>         int tmp_level = 0;
>         int tmp_qual = 0;
>         int tmp_noise = 0;
> +
>         if (ieee->state < IEEE80211_LINKED) {
>                 wstats->qual.qual = 0;
>                 wstats->qual.level = 0;
> @@ -992,12 +990,11 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
>         tmp_level = (&ieee->current_network)->stats.rssi;
>         tmp_qual = (&ieee->current_network)->stats.signal;
>         tmp_noise = (&ieee->current_network)->stats.noise;
> -       //printk("level:%d, qual:%d, noise:%d\n", tmp_level, tmp_qual, tmp_noise);
>
>         wstats->qual.level = tmp_level;
>         wstats->qual.qual = tmp_qual;
>         wstats->qual.noise = tmp_noise;
> -       wstats->qual.updated = IW_QUAL_ALL_UPDATED| IW_QUAL_DBM;
> +       wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
>         return wstats;
>  }
>
> --
> 1.9.1
>
