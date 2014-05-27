Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaE0R4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:56:01 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:41796 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaE0Rz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:55:59 -0400
MIME-Version: 1.0
X-Originating-IP: [128.107.151.95]
In-Reply-To: <CAHb8M2C1nwunPTOzhb43wR2ozZMPZSRh_+o5fW5ODKNH7TozOA@mail.gmail.com>
References: <1401169412-4831-1-git-send-email-c@24.io>
	<CAHb8M2C1nwunPTOzhb43wR2ozZMPZSRh_+o5fW5ODKNH7TozOA@mail.gmail.com>
Date: Tue, 27 May 2014 10:55:58 -0700
Message-ID: <CADadk9H6Yzs6K3_3rcPim5QquVcT1A9mnPZVbXn7xLjPGKORuw@mail.gmail.com>
Subject: Re: [PATCH] Staging: rtl8192u: r8180_93cx6.c & r8192U_wx.c fix
 checkpatch.pl errors and warnings
From: Chaitanya Hazarey <c@24.io>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "andrea.merello" <andrea.merello@gmail.com>,
        linville <linville@tuxdriver.com>, burzalodowa <burzalodowa@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey there,

Thanks for looking into this,

Will be sending out the modified version soon.

Thanks,

Chaitanya

On Mon, May 26, 2014 at 11:56 PM, DaeSeok Youn <daeseok.youn@gmail.com> wrote:
> Hi,
>
> 2014-05-27 14:43 GMT+09:00 Chaitanya Hazarey <c@24.io>:
>> Fixed the following:
>>
>> ERROR: do not use C99 // comments
>> ERROR: else should follow close brace '}'
>> ERROR: need consistent spacing around '*' (ctx:WxV)
>> ERROR: need consistent spacing around '|' (ctx:VxW)
>> ERROR: space prohibited after that open parenthesis '('
>> ERROR: space prohibited before that '--' (ctx:WxO)
>> ERROR: space prohibited before that close parenthesis ')'
>> ERROR: space required after that ',' (ctx:VxV)
>> ERROR: space required after that ';' (ctx:VxV)
>> ERROR: space required after that close brace '}'
>> ERROR: space required before the open brace '{'
>> ERROR: space required before the open parenthesis '('
>> ERROR: spaces required around that '!=' (ctx:VxV)
>> ERROR: spaces required around that '!=' (ctx:WxV)
>> ERROR: spaces required around that '&&' (ctx:VxV)
>> ERROR: spaces required around that '<' (ctx:VxV)
>> ERROR: spaces required around that '=' (ctx:VxV)
>> ERROR: spaces required around that '=' (ctx:VxW)
>> ERROR: spaces required around that '=' (ctx:WxV)
>> ERROR: spaces required around that '==' (ctx:VxV)
>> ERROR: that open brace { should be on the previous line
>> ERROR: trailing statements should be on next line
>> WARNING: Missing a blank line after declarations
>> WARNING: missing space after struct definition
>> WARNING: please, no spaces at the start of a line
>> WARNING: suspect code indent for conditional statements (16, 16)
>
> Please break this up into smaller patches.
> And need to resend this patch.
>>
>> Signed-off-by: Chaitanya Hazarey <c@24.io>
>> ---
>>  drivers/staging/rtl8192u/r8180_93cx6.c |   58 ++---
>>  drivers/staging/rtl8192u/r8192U_wx.c   |  373 +++++++++++++++++---------------
>>  2 files changed, 223 insertions(+), 208 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
>> index cd06054..7a0051e 100644
>> --- a/drivers/staging/rtl8192u/r8180_93cx6.c
>> +++ b/drivers/staging/rtl8192u/r8180_93cx6.c
>> @@ -53,7 +53,7 @@ static void eprom_ck_cycle(struct net_device *dev)
>>  }
>>
>>
>> -static void eprom_w(struct net_device *dev,short bit)
>> +static void eprom_w(struct net_device *dev, short bit)
>>  {
>>         u8 cmdreg;
>>
>> @@ -86,7 +86,7 @@ static void eprom_send_bits_string(struct net_device *dev, short b[], int len)
>>  {
>>         int i;
>>
>> -       for(i=0; i<len; i++){
>> +       for (i = 0 ; i < len ; i++) {
> I think it doesn't need to add a space between "i = 0" and ";".
> just like below:
> for (i = 0; i < len; i++) {
>
>>                 eprom_w(dev, b[i]);
>>                 eprom_ck_cycle(dev);
>>         }
>> @@ -96,50 +96,50 @@ static void eprom_send_bits_string(struct net_device *dev, short b[], int len)
>>  u32 eprom_read(struct net_device *dev, u32 addr)
>>  {
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>> -       short read_cmd[]={1,1,0};
>> +       short read_cmd[] = {1, 1, 0};
>>         short addr_str[8];
>>         int i;
>>         int addr_len;
>>         u32 ret;
>>
>> -       ret=0;
>> -       //enable EPROM programming
>> +       ret = 0;
>> +       /* enable EPROM programming */
>>         write_nic_byte_E(dev, EPROM_CMD,
>>                        (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
>>         force_pci_posting(dev);
>>         udelay(EPROM_DELAY);
>>
>> -       if (priv->epromtype==EPROM_93c56){
>> -               addr_str[7]=addr & 1;
>> -               addr_str[6]=addr & (1<<1);
>> -               addr_str[5]=addr & (1<<2);
>> -               addr_str[4]=addr & (1<<3);
>> -               addr_str[3]=addr & (1<<4);
>> -               addr_str[2]=addr & (1<<5);
>> -               addr_str[1]=addr & (1<<6);
>> -               addr_str[0]=addr & (1<<7);
>> -               addr_len=8;
>> -       }else{
>> -               addr_str[5]=addr & 1;
>> -               addr_str[4]=addr & (1<<1);
>> -               addr_str[3]=addr & (1<<2);
>> -               addr_str[2]=addr & (1<<3);
>> -               addr_str[1]=addr & (1<<4);
>> -               addr_str[0]=addr & (1<<5);
>> -               addr_len=6;
>> +       if (priv->epromtype == EPROM_93c56) {
>> +               addr_str[7] = addr & 1;
>> +               addr_str[6] = addr & (1<<1);
>> +               addr_str[5] = addr & (1<<2);
>> +               addr_str[4] = addr & (1<<3);
>> +               addr_str[3] = addr & (1<<4);
>> +               addr_str[2] = addr & (1<<5);
>> +               addr_str[1] = addr & (1<<6);
>> +               addr_str[0] = addr & (1<<7);
>> +               addr_len = 8;
>> +       } else {
>> +               addr_str[5] = addr & 1;
>> +               addr_str[4] = addr & (1<<1);
>> +               addr_str[3] = addr & (1<<2);
>> +               addr_str[2] = addr & (1<<3);
>> +               addr_str[1] = addr & (1<<4);
>> +               addr_str[0] = addr & (1<<5);
>> +               addr_len = 6;
>>         }
>>         eprom_cs(dev, 1);
>>         eprom_ck_cycle(dev);
>>         eprom_send_bits_string(dev, read_cmd, 3);
>>         eprom_send_bits_string(dev, addr_str, addr_len);
>>
>> -       //keep chip pin D to low state while reading.
>> -       //I'm unsure if it is necessary, but anyway shouldn't hurt
>> +       /* keep chip pin D to low state while reading.*/
>> +       /* I'm unsure if it is necessary, but anyway shouldn't hurt*/
>>         eprom_w(dev, 0);
>>
>> -       for(i=0;i<16;i++){
>> -               //eeprom needs a clk cycle between writing opcode&adr
>> -               //and reading data. (eeprom outs a dummy 0)
>> +       for (i = 0 ; i < 16 ; i++) {
> same above my comment.
>
>> +               /* eeprom needs a clk cycle between writing opcode&adr */
>> +               /* and reading data. (eeprom outs a dummy 0) */
>>                 eprom_ck_cycle(dev);
>>                 ret |= (eprom_r(dev)<<(15-i));
>>         }
>> @@ -147,7 +147,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
>>         eprom_cs(dev, 0);
>>         eprom_ck_cycle(dev);
>>
>> -       //disable EPROM programming
>> +       /* disable EPROM programming */
>>         write_nic_byte_E(dev, EPROM_CMD,
>>                        (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
>>         return ret;
>> diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
>> index dab716f..5dd0654 100644
>> --- a/drivers/staging/rtl8192u/r8192U_wx.c
>> +++ b/drivers/staging/rtl8192u/r8192U_wx.c
>> @@ -24,8 +24,8 @@
>>  #include "dot11d.h"
>>
>>  #define RATE_COUNT 12
>> -u32 rtl8180_rates[] = {1000000,2000000,5500000,11000000,
>> -       6000000,9000000,12000000,18000000,24000000,36000000,48000000,54000000};
>> +u32 rtl8180_rates[] = {1000000, 2000000, 5500000, 11000000,
>> +       6000000, 9000000, 12000000, 18000000, 24000000, 36000000, 48000000, 54000000};
>>
>>
>>  #ifndef ENETDOWN
>> @@ -38,16 +38,16 @@ static int r8192_wx_get_freq(struct net_device *dev,
>>  {
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>>
>> -       return ieee80211_wx_get_freq(priv->ieee80211,a,wrqu,b);
>> +       return ieee80211_wx_get_freq(priv->ieee80211, a, wrqu, b);
>>  }
>>
>>
>>  static int r8192_wx_get_mode(struct net_device *dev, struct iw_request_info *a,
>>                              union iwreq_data *wrqu, char *b)
>>  {
>> -       struct r8192_priv *priv=ieee80211_priv(dev);
>> +       struct r8192_priv *priv = ieee80211_priv(dev);
>>
>> -       return ieee80211_wx_get_mode(priv->ieee80211,a,wrqu,b);
>> +       return ieee80211_wx_get_mode(priv->ieee80211, a, wrqu, b);
>>  }
>>
>>
>> @@ -57,7 +57,8 @@ static int r8192_wx_get_rate(struct net_device *dev,
>>                              union iwreq_data *wrqu, char *extra)
>>  {
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>> -       return ieee80211_wx_get_rate(priv->ieee80211,info,wrqu,extra);
>> +
>> +       return ieee80211_wx_get_rate(priv->ieee80211, info, wrqu, extra);
>>  }
>>
>>
>> @@ -71,7 +72,7 @@ static int r8192_wx_set_rate(struct net_device *dev,
>>
>>         down(&priv->wx_sem);
>>
>> -       ret = ieee80211_wx_set_rate(priv->ieee80211,info,wrqu,extra);
>> +       ret = ieee80211_wx_set_rate(priv->ieee80211, info, wrqu, extra);
>>
>>         up(&priv->wx_sem);
>>
>> @@ -88,7 +89,7 @@ static int r8192_wx_set_rts(struct net_device *dev,
>>
>>         down(&priv->wx_sem);
>>
>> -       ret = ieee80211_wx_set_rts(priv->ieee80211,info,wrqu,extra);
>> +       ret = ieee80211_wx_set_rts(priv->ieee80211, info, wrqu, extra);
>>
>>         up(&priv->wx_sem);
>>
>> @@ -100,7 +101,7 @@ static int r8192_wx_get_rts(struct net_device *dev,
>>                              union iwreq_data *wrqu, char *extra)
>>  {
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>> -       return ieee80211_wx_get_rts(priv->ieee80211,info,wrqu,extra);
>> +       return ieee80211_wx_get_rts(priv->ieee80211, info, wrqu, extra);
>>  }
>>
>>  static int r8192_wx_set_power(struct net_device *dev,
>> @@ -112,7 +113,7 @@ static int r8192_wx_set_power(struct net_device *dev,
>>
>>         down(&priv->wx_sem);
>>
>> -       ret = ieee80211_wx_set_power(priv->ieee80211,info,wrqu,extra);
>> +       ret = ieee80211_wx_set_power(priv->ieee80211, info, wrqu, extra);
>>
>>         up(&priv->wx_sem);
>>
>> @@ -124,7 +125,8 @@ static int r8192_wx_get_power(struct net_device *dev,
>>                              union iwreq_data *wrqu, char *extra)
>>  {
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>> -       return ieee80211_wx_get_power(priv->ieee80211,info,wrqu,extra);
>> +
>> +       return ieee80211_wx_get_power(priv->ieee80211, info, wrqu, extra);
>>  }
>>
>>  static int r8192_wx_force_reset(struct net_device *dev,
>> @@ -135,7 +137,7 @@ static int r8192_wx_force_reset(struct net_device *dev,
>>
>>         down(&priv->wx_sem);
>>
>> -       printk("%s(): force reset ! extra is %d\n",__func__, *extra);
>> +       printk("%s(): force reset ! extra is %d\n", __func__, *extra);
>>         priv->force_reset = *extra;
>>         up(&priv->wx_sem);
>>         return 0;
>> @@ -171,17 +173,17 @@ static int r8192_wx_set_crcmon(struct net_device *dev,
>>
>>         down(&priv->wx_sem);
>>
>> -       if(enable)
>> -               priv->crcmon=1;
>> +       if (enable)
>> +               priv->crcmon = 1;
>>         else
>> -               priv->crcmon=0;
>> +               priv->crcmon = 0;
>>
>>         DMESG("bad CRC in monitor mode are %s",
>>               priv->crcmon ? "accepted" : "rejected");
>>
>> -       if(prev != priv->crcmon && priv->up){
>> -               //rtl8180_down(dev);
>> -               //rtl8180_up(dev);
>> +       if (prev != priv->crcmon && priv->up) {
>> +               /*rtl8180_down(dev);*/
>> +               /*rtl8180_up(dev);*/
>>         }
>>
>>         up(&priv->wx_sem);
>> @@ -194,9 +196,10 @@ static int r8192_wx_set_mode(struct net_device *dev, struct iw_request_info *a,
>>  {
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>>         int ret;
>> +
>>         down(&priv->wx_sem);
>>
>> -       ret = ieee80211_wx_set_mode(priv->ieee80211,a,wrqu,b);
>> +       ret = ieee80211_wx_set_mode(priv->ieee80211, a, wrqu, b);
>>
>>         rtl8192_set_rxconf(dev);
>>
>> @@ -249,16 +252,16 @@ static int rtl8180_wx_get_range(struct net_device *dev,
>>         /* ~5 Mb/s real (802.11b) */
>>         range->throughput = 5 * 1000 * 1000;
>>
>> -       // TODO: Not used in 802.11b?
>> -//     range->min_nwid;        /* Minimal NWID we are able to set */
>> -       // TODO: Not used in 802.11b?
>> -//     range->max_nwid;        /* Maximal NWID we are able to set */
>> +       /* TODO: Not used in 802.11b? */
>> +/*     range->min_nwid; */     /* Minimal NWID we are able to set */
>> +       /* TODO: Not used in 802.11b? */
>> +/*     range->max_nwid; */     /* Maximal NWID we are able to set */
>>
>>         /* Old Frequency (backward compat - moved lower ) */
>> -//     range->old_num_channels;
>> -//     range->old_num_frequency;
>> -//     range->old_freq[6]; /* Filler to keep "version" at the same offset */
>> -       if(priv->rf_set_sens != NULL)
>> +/*     range->old_num_channels; */
>> +/*     range->old_num_frequency; */
>> +/*     range->old_freq[6]; */ /* Filler to keep "version" at the same offset */
>> +       if (priv->rf_set_sens != NULL)
>>                 range->sensitivity = priv->max_sens;    /* signal level threshold range */
>>
>>         range->max_qual.qual = 100;
>> @@ -281,7 +284,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
>>         range->min_frag = MIN_FRAG_THRESHOLD;
>>         range->max_frag = MAX_FRAG_THRESHOLD;
>>
>> -       range->min_pmp=0;
>> +       range->min_pmp = 0;
>>         range->max_pmp = 5000000;
>>         range->min_pmt = 0;
>>         range->max_pmt = 65535*1000;
>> @@ -292,30 +295,30 @@ static int rtl8180_wx_get_range(struct net_device *dev,
>>         range->we_version_compiled = WIRELESS_EXT;
>>         range->we_version_source = 16;
>>
>> -//     range->retry_capa;      /* What retry options are supported */
>> -//     range->retry_flags;     /* How to decode max/min retry limit */
>> -//     range->r_time_flags;    /* How to decode max/min retry life */
>> -//     range->min_retry;       /* Minimal number of retries */
>> -//     range->max_retry;       /* Maximal number of retries */
>> -//     range->min_r_time;      /* Minimal retry lifetime */
>> -//     range->max_r_time;      /* Maximal retry lifetime */
>> +/*     range->retry_capa; */   /* What retry options are supported */
>> +/*     range->retry_flags; */  /* How to decode max/min retry limit */
>> +/*     range->r_time_flags; */ /* How to decode max/min retry life */
>> +/*     range->min_retry; */    /* Minimal number of retries */
>> +/*     range->max_retry; */    /* Maximal number of retries */
>> +/*     range->min_r_time; */   /* Minimal retry lifetime */
>> +/*     range->max_r_time; */   /* Maximal retry lifetime */
>>
>>
>>         for (i = 0, val = 0; i < 14; i++) {
>>
>> -               // Include only legal frequencies for some countries
>> +               /* Include only legal frequencies for some countries */
>>                 if ((GET_DOT11D_INFO(priv->ieee80211)->channel_map)[i+1]) {
>>                         range->freq[val].i = i + 1;
>>                         range->freq[val].m = ieee80211_wlan_frequencies[i] * 100000;
>>                         range->freq[val].e = 1;
>>                         val++;
>>                 } else {
>> -                       // FIXME: do we need to set anything for channels
>> -                       // we don't use ?
>> +                       /* FIXME: do we need to set anything for channels */
>> +                       /* we don't use ? */
>>                 }
>>
>>                 if (val == IW_MAX_FREQUENCIES)
>> -               break;
>> +                       break;
>>         }
>>         range->num_frequency = val;
>>         range->num_channels = val;
>> @@ -333,30 +336,28 @@ static int r8192_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
>>         struct ieee80211_device *ieee = priv->ieee80211;
>>         int ret = 0;
>>
>> -       if(!priv->up) return -ENETDOWN;
>> +       if (!priv->up)
>> +               return -ENETDOWN;
>>
>>         if (priv->ieee80211->LinkDetectInfo.bBusyTraffic == true)
>>                 return -EAGAIN;
>> -       if (wrqu->data.flags & IW_SCAN_THIS_ESSID)
>> -       {
>> +       if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
>>                 struct iw_scan_req *req = (struct iw_scan_req *)b;
>> -               if (req->essid_len)
>> -               {
>> -                       //printk("==**&*&*&**===>scan set ssid:%s\n", req->essid);
>> +               if (req->essid_len) {
>> +                       /* printk("==**&*&*&**===>scan set ssid:%s\n", req->essid); */
> this dead code can be removed.
>>                         ieee->current_network.ssid_len = req->essid_len;
>>                         memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
>> -                       //printk("=====>network ssid:%s\n", ieee->current_network.ssid);
>> +                       /* printk("=====>network ssid:%s\n", ieee->current_network.ssid); */
> this dead code can be removed.
>>                 }
>>         }
>>
>>         down(&priv->wx_sem);
>> -       if(priv->ieee80211->state != IEEE80211_LINKED){
>> +       if (priv->ieee80211->state != IEEE80211_LINKED) {
>>                 priv->ieee80211->scanning = 0;
>>                 ieee80211_softmac_scan_syncro(priv->ieee80211);
>>                 ret = 0;
>> -       }
>> -       else
>> -       ret = ieee80211_wx_set_scan(priv->ieee80211,a,wrqu,b);
>> +       } else
>> +               ret = ieee80211_wx_set_scan(priv->ieee80211, a, wrqu, b);
> "if" has a curly brace and then "else" add brace also.
>
>>         up(&priv->wx_sem);
>>         return ret;
>>  }
>> @@ -369,11 +370,12 @@ static int r8192_wx_get_scan(struct net_device *dev, struct iw_request_info *a,
>>         int ret;
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>>
>> -       if(!priv->up) return -ENETDOWN;
>> +       if (!priv->up)
>> +               return -ENETDOWN;
>>
>>         down(&priv->wx_sem);
>>
>> -       ret = ieee80211_wx_get_scan(priv->ieee80211,a,wrqu,b);
>> +       ret = ieee80211_wx_get_scan(priv->ieee80211, a, wrqu, b);
>>
>>         up(&priv->wx_sem);
>>
>> @@ -386,9 +388,10 @@ static int r8192_wx_set_essid(struct net_device *dev,
>>  {
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>>         int ret;
>> +
>>         down(&priv->wx_sem);
>>
>> -       ret = ieee80211_wx_set_essid(priv->ieee80211,a,wrqu,b);
>> +       ret = ieee80211_wx_set_essid(priv->ieee80211, a, wrqu, b);
>>
>>         up(&priv->wx_sem);
>>
>> @@ -480,10 +483,11 @@ static int r8192_wx_set_wap(struct net_device *dev,
>>
>>         int ret;
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>> -//        struct sockaddr *temp = (struct sockaddr *)awrq;
>> +/*      struct sockaddr *temp = (struct sockaddr *)awrq; */
>> +
>>         down(&priv->wx_sem);
>>
>> -       ret = ieee80211_wx_set_wap(priv->ieee80211,info,awrq,extra);
>> +       ret = ieee80211_wx_set_wap(priv->ieee80211, info, awrq, extra);
>>
>>         up(&priv->wx_sem);
>>
>> @@ -498,7 +502,7 @@ static int r8192_wx_get_wap(struct net_device *dev,
>>  {
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>>
>> -       return ieee80211_wx_get_wap(priv->ieee80211,info,wrqu,extra);
>> +       return ieee80211_wx_get_wap(priv->ieee80211, info, wrqu, extra);
>>  }
>>
>>
>> @@ -519,35 +523,38 @@ static int r8192_wx_set_enc(struct net_device *dev,
>>         struct ieee80211_device *ieee = priv->ieee80211;
>>         int ret;
>>
>> -       //u32 TargetContent;
>> -       u32 hwkey[4]={0,0,0,0};
>> -       u8 mask=0xff;
>> -       u32 key_idx=0;
>> -       //u8 broadcast_addr[6] ={       0xff,0xff,0xff,0xff,0xff,0xff};
>> -       u8 zero_addr[4][6] ={   {0x00,0x00,0x00,0x00,0x00,0x00},
>> -                               {0x00,0x00,0x00,0x00,0x00,0x01},
>> -                               {0x00,0x00,0x00,0x00,0x00,0x02},
>> -                               {0x00,0x00,0x00,0x00,0x00,0x03} };
>> +       /*u32 TargetContent; */
>> +       u32 hwkey[4] = {0, 0, 0, 0};
>> +       u8 mask = 0xff;
>> +       u32 key_idx = 0;
>> +       /*u8 broadcast_addr[6] ={       0xff,0xff,0xff,0xff,0xff,0xff}; */
> Is this really needed?
>> +       u8 zero_addr[4][6] = {  {0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
>> +                               {0x00, 0x00, 0x00, 0x00, 0x00, 0x01},
>> +                               {0x00, 0x00, 0x00, 0x00, 0x00, 0x02},
>> +                               {0x00, 0x00, 0x00, 0x00, 0x00, 0x03} };
>>         int i;
>>
>> -       if(!priv->up) return -ENETDOWN;
>> +       if (!priv->up)
>> +               return -ENETDOWN;
>>
>>         down(&priv->wx_sem);
>>
>>         RT_TRACE(COMP_SEC, "Setting SW wep key");
>> -       ret = ieee80211_wx_set_encode(priv->ieee80211,info,wrqu,key);
>> +       ret = ieee80211_wx_set_encode(priv->ieee80211, info, wrqu, key);
>>
>>         up(&priv->wx_sem);
>>
>>
>>
>> -       //sometimes, the length is zero while we do not type key value
>> -       if(wrqu->encoding.length!=0){
>> +       /*sometimes, the length is zero while we do not type key value */
>> +       if (wrqu->encoding.length != 0) {
>>
>> -               for(i=0 ; i<4 ; i++){
>> +               for (i = 0 ; i < 4 ; i++) {
>>                         hwkey[i] |=  key[4*i+0]&mask;
>> -                       if(i==1&&(4*i+1)==wrqu->encoding.length) mask=0x00;
>> -                       if(i==3&&(4*i+1)==wrqu->encoding.length) mask=0x00;
>> +                       if (i == 1 && (4*i+1) == wrqu->encoding.length)
>> +                               mask = 0x00;
>> +                       if (i == 3 && (4*i+1) == wrqu->encoding.length)
>> +                               mask = 0x00;
> this "if" condition like below:
> if (5 == wrqu->encoding.length || 13 == wrqu->encoding.length)
>       mask = 0x00;
> and this should be outside "for" loop
>
>>                         hwkey[i] |= (key[4*i+1]&mask)<<8;
>>                         hwkey[i] |= (key[4*i+2]&mask)<<16;
>>                         hwkey[i] |= (key[4*i+3]&mask)<<24;
>> @@ -556,43 +563,54 @@ static int r8192_wx_set_enc(struct net_device *dev,
>>                 #define CONF_WEP40  0x4
>>                 #define CONF_WEP104 0x14
>>
>> -               switch (wrqu->encoding.flags & IW_ENCODE_INDEX){
>> -               case 0: key_idx = ieee->tx_keyidx; break;
>> -               case 1: key_idx = 0; break;
>> -               case 2: key_idx = 1; break;
>> -               case 3: key_idx = 2; break;
>> -               case 4: key_idx = 3; break;
>> -               default: break;
>> +               switch (wrqu->encoding.flags & IW_ENCODE_INDEX) {
>> +               case 0:
>> +                       key_idx = ieee->tx_keyidx;
>> +                       break;
>> +               case 1:
>> +                       key_idx = 0;
>> +                       break;
>> +               case 2:
>> +                       key_idx = 1;
>> +                       break;
>> +               case 3:
>> +                       key_idx = 2;
>> +                       break;
>> +               case 4:
>> +                       key_idx = 3;
>> +                       break;
>> +               default:
>> +                       break;
>>                 }
>>
>> -               if(wrqu->encoding.length==0x5){
>> +               if (wrqu->encoding.length == 0x5) {
>>                                 ieee->pairwise_key_type = KEY_TYPE_WEP40;
>>                         EnableHWSecurityConfig8192(dev);
>>
>> -                       setKey( dev,
>> -                               key_idx,                //EntryNo
>> -                               key_idx,                //KeyIndex
>> -                               KEY_TYPE_WEP40,         //KeyType
>> +                       setKey(dev,
>> +                               key_idx,                /*EntryNo */
>> +                               key_idx,                /*KeyIndex */
>> +                               KEY_TYPE_WEP40,         /*KeyType */
>>                                 zero_addr[key_idx],
>> -                               0,                      //DefaultKey
>> -                               hwkey);                 //KeyContent
>> +                               0,                      /*DefaultKey */
>> +                               hwkey);                 /*KeyContent */
>>
>>                 }
>>
>> -               else if(wrqu->encoding.length==0xd){
>> +               else if (wrqu->encoding.length == 0xd) {
>>                                 ieee->pairwise_key_type = KEY_TYPE_WEP104;
>>                                 EnableHWSecurityConfig8192(dev);
>>
>> -                       setKey( dev,
>> -                               key_idx,                //EntryNo
>> -                               key_idx,                //KeyIndex
>> -                               KEY_TYPE_WEP104,        //KeyType
>> +                       setKey(dev,
>> +                               key_idx,                /*EntryNo */
>> +                               key_idx,                /*KeyIndex */
>> +                               KEY_TYPE_WEP104,        /*KeyType */
>>                                 zero_addr[key_idx],
>> -                               0,                      //DefaultKey
>> -                               hwkey);                 //KeyContent
>> +                               0,                      /*DefaultKey */
>> +                               hwkey);                 /*KeyContent */
>>
>> -               }
>> -               else printk("wrong type in WEP, not WEP40 and WEP104\n");
>> +               } else
>> +                       printk("wrong type in WEP, not WEP40 and WEP104\n");
>>
>>         }
>>
>> @@ -600,12 +618,12 @@ static int r8192_wx_set_enc(struct net_device *dev,
>>  }
>>
>>
>> -static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa, union
>> - iwreq_data *wrqu, char *p){
>> +static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa,
>> +                                       union iwreq_data *wrqu, char *p){
>>
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>> -       int *parms=(int *)p;
>> -       int mode=parms[0];
>> +       int *parms = (int *)p;
>> +       int mode = parms[0];
>>
>>         priv->ieee80211->active_scan = mode;
>>
>> @@ -624,24 +642,24 @@ static int r8192_wx_set_retry(struct net_device *dev,
>>         down(&priv->wx_sem);
>>
>>         if (wrqu->retry.flags & IW_RETRY_LIFETIME ||
>> -           wrqu->retry.disabled){
>> +           wrqu->retry.disabled) {
>>                 err = -EINVAL;
>>                 goto exit;
>>         }
>> -       if (!(wrqu->retry.flags & IW_RETRY_LIMIT)){
>> +       if (!(wrqu->retry.flags & IW_RETRY_LIMIT)) {
>>                 err = -EINVAL;
>>                 goto exit;
>>         }
>>
>> -       if(wrqu->retry.value > R8180_MAX_RETRY){
>> -               err= -EINVAL;
>> +       if (wrqu->retry.value > R8180_MAX_RETRY) {
>> +               err = -EINVAL;
>>                 goto exit;
>>         }
>>         if (wrqu->retry.flags & IW_RETRY_MAX) {
>>                 priv->retry_rts = wrqu->retry.value;
>>                 DMESG("Setting retry for RTS/CTS data to %d", wrqu->retry.value);
>>
>> -       }else {
>> +       } else {
>>                 priv->retry_data = wrqu->retry.value;
>>                 DMESG("Setting retry for non RTS/CTS data to %d", wrqu->retry.value);
>>         }
>> @@ -687,7 +705,7 @@ static int r8192_wx_get_retry(struct net_device *dev,
>>                 wrqu->retry.flags = IW_RETRY_LIMIT | IW_RETRY_MIN;
>>                 wrqu->retry.value = priv->retry_data;
>>         }
>> -       //printk("returning %d",wrqu->retry.value);
>> +       /* printk("returning %d",wrqu->retry.value); */
>>
>>
>>         return 0;
>> @@ -698,7 +716,8 @@ static int r8192_wx_get_sens(struct net_device *dev,
>>                                 union iwreq_data *wrqu, char *extra)
>>  {
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>> -       if(priv->rf_set_sens == NULL)
>> +
>> +       if (priv->rf_set_sens == NULL)
>>                 return -1; /* we have not this support for this radio */
>>         wrqu->sens.value = priv->sens;
>>         return 0;
>> @@ -714,15 +733,15 @@ static int r8192_wx_set_sens(struct net_device *dev,
>>
>>         short err = 0;
>>         down(&priv->wx_sem);
>> -       //DMESG("attempt to set sensivity to %ddb",wrqu->sens.value);
>> -       if(priv->rf_set_sens == NULL) {
>> -               err= -1; /* we have not this support for this radio */
>> +       /*DMESG("attempt to set sensivity to %ddb",wrqu->sens.value);*/
>> +       if (priv->rf_set_sens == NULL) {
>> +               err = -1; /* we have not this support for this radio */
>>                 goto exit;
>>         }
>> -       if(priv->rf_set_sens(dev, wrqu->sens.value) == 0)
>> +       if (priv->rf_set_sens(dev, wrqu->sens.value) == 0)
>>                 priv->sens = wrqu->sens.value;
>>         else
>> -               err= -EINVAL;
>> +               err = -EINVAL;
>>
>>  exit:
>>         up(&priv->wx_sem);
>> @@ -730,77 +749,72 @@ exit:
>>         return err;
>>  }
>>
>> -//hw security need to reorganized.
>> +/*hw security need to reorganized. */
>>  static int r8192_wx_set_enc_ext(struct net_device *dev,
>>                                         struct iw_request_info *info,
>>                                         union iwreq_data *wrqu, char *extra)
>>  {
>> -       int ret=0;
>> +       int ret = 0;
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>>         struct ieee80211_device *ieee = priv->ieee80211;
>> -       //printk("===>%s()\n", __func__);
>> +
>> +       /* printk("===>%s()\n", __func__); */
> this line can be removed.
>>
>>
>>         down(&priv->wx_sem);
>>         ret = ieee80211_wx_set_encode_ext(priv->ieee80211, info, wrqu, extra);
>>
>>         {
>> -               u8 broadcast_addr[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
>> +               u8 broadcast_addr[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
>>                 u8 zero[6] = {0};
>>                 u32 key[4] = {0};
>>                 struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
>>                 struct iw_point *encoding = &wrqu->encoding;
>>                 u8 idx = 0, alg = 0, group = 0;
>>                 if ((encoding->flags & IW_ENCODE_DISABLED) ||
>> -               ext->alg == IW_ENCODE_ALG_NONE) //none is not allowed to use hwsec WB 2008.07.01
>> +               ext->alg == IW_ENCODE_ALG_NONE) /*none is not allowed to use hwsec WB 2008.07.01 */
> over 80 character.
>>                         goto end_hw_sec;
>>
>> -               alg =  (ext->alg == IW_ENCODE_ALG_CCMP)?KEY_TYPE_CCMP:ext->alg; // as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4;
>> +               alg =  (ext->alg == IW_ENCODE_ALG_CCMP)?KEY_TYPE_CCMP:ext->alg; /* as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4; */
> over 80 character in a line.
>
>>                 idx = encoding->flags & IW_ENCODE_INDEX;
>>                 if (idx)
>> -                       idx --;
>> +                       idx--;
>>                 group = ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY;
>>
>> -               if ((!group) || (IW_MODE_ADHOC == ieee->iw_mode) || (alg ==  KEY_TYPE_WEP40))
>> -               {
>> -                       if ((ext->key_len == 13) && (alg == KEY_TYPE_WEP40) )
>> +               if ((!group) || (IW_MODE_ADHOC == ieee->iw_mode) || (alg ==  KEY_TYPE_WEP40)) {
>> +                       if ((ext->key_len == 13) && (alg == KEY_TYPE_WEP40))
>>                                 alg = KEY_TYPE_WEP104;
>>                         ieee->pairwise_key_type = alg;
>>                         EnableHWSecurityConfig8192(dev);
>>                 }
>> -               memcpy((u8 *)key, ext->key, 16); //we only get 16 bytes key.why? WB 2008.7.1
>> -
>> -               if ((alg & KEY_TYPE_WEP40) && (ieee->auth_mode !=2) )
>> -               {
>> -
>> -                       setKey( dev,
>> -                                       idx,//EntryNo
>> -                                       idx, //KeyIndex
>> -                                       alg,  //KeyType
>> -                                       zero, //MacAddr
>> -                                       0,              //DefaultKey
>> -                                       key);           //KeyContent
>> -               }
>> -               else if (group)
>> -               {
>> +               memcpy((u8 *)key, ext->key, 16); /*we only get 16 bytes key.why? WB 2008.7.1 */
>> +
>> +               if ((alg & KEY_TYPE_WEP40) && (ieee->auth_mode != 2)) {
>> +
>> +                       setKey(dev,
>> +                                       idx,/*EntryNo */
>> +                                       idx, /*KeyIndex */
>> +                                       alg,  /*KeyType */
>> +                                       zero, /*MacAddr */
>> +                                       0,              /*DefaultKey */
>> +                                       key);           /*KeyContent */
>> +               } else if (group) {
>>                         ieee->group_key_type = alg;
>> -                       setKey( dev,
>> -                                       idx,//EntryNo
>> -                                       idx, //KeyIndex
>> -                                       alg,  //KeyType
>> -                                       broadcast_addr, //MacAddr
>> -                                       0,              //DefaultKey
>> -                                       key);           //KeyContent
>> -               }
>> -               else //pairwise key
>> -               {
>> -                       setKey( dev,
>> -                                       4,//EntryNo
>> -                                       idx, //KeyIndex
>> -                                       alg,  //KeyType
>> -                                       (u8 *)ieee->ap_mac_addr, //MacAddr
>> -                                       0,              //DefaultKey
>> -                                       key);           //KeyContent
>> +                       setKey(dev,
>> +                                       idx,/*EntryNo */
>> +                                       idx, /*KeyIndex */
>> +                                       alg,  /*KeyType */
>> +                                       broadcast_addr, /*MacAddr */
>> +                                       0,              /*DefaultKey */
>> +                                       key);           /*KeyContent */
>> +               } else /*pairwise key */ {
>> +                       setKey(dev,
>> +                                       4,/*EntryNo */
>> +                                       idx, /*KeyIndex */
>> +                                       alg,  /*KeyType */
>> +                                       (u8 *)ieee->ap_mac_addr, /*MacAddr */
>> +                                       0,              /*DefaultKey */
>> +                                       key);           /*KeyContent */
>>                 }
>>
>>
>> @@ -816,9 +830,10 @@ static int r8192_wx_set_auth(struct net_device *dev,
>>                                         struct iw_request_info *info,
>>                                         union iwreq_data *data, char *extra)
>>  {
>> -       int ret=0;
>> -       //printk("====>%s()\n", __func__);
>> +       int ret = 0;
>> +       /*printk("====>%s()\n", __func__); */
> remove.
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>> +
>>         down(&priv->wx_sem);
>>         ret = ieee80211_wx_set_auth(priv->ieee80211, info, &(data->param), extra);
>>         up(&priv->wx_sem);
>> @@ -829,10 +844,11 @@ static int r8192_wx_set_mlme(struct net_device *dev,
>>                                         struct iw_request_info *info,
>>                                         union iwreq_data *wrqu, char *extra)
>>  {
>> -       //printk("====>%s()\n", __func__);
>> +       /*printk("====>%s()\n", __func__); */
> remove.
>>
>> -       int ret=0;
>> +       int ret = 0;
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>> +
>>         down(&priv->wx_sem);
>>         ret = ieee80211_wx_set_mlme(priv->ieee80211, info, wrqu, extra);
>>
>> @@ -844,27 +860,27 @@ static int r8192_wx_set_gen_ie(struct net_device *dev,
>>                                         struct iw_request_info *info,
>>                                         union iwreq_data *data, char *extra)
>>  {
>> -          //printk("====>%s(), len:%d\n", __func__, data->length);
>> -       int ret=0;
>> +       /*printk("====>%s(), len:%d\n", __func__, data->length); */
> remove.
>> +       int ret = 0;
>>         struct r8192_priv *priv = ieee80211_priv(dev);
>> +
>>         down(&priv->wx_sem);
>>         ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, data->data.length);
>>         up(&priv->wx_sem);
>> -       //printk("<======%s(), ret:%d\n", __func__, ret);
>> +       /*printk("<======%s(), ret:%d\n", __func__, ret); */
> remove this.
>>         return ret;
>>
>>
>>  }
>>
>>  static int dummy(struct net_device *dev, struct iw_request_info *a,
>> -                union iwreq_data *wrqu,char *b)
>> +                union iwreq_data *wrqu, char *b)
>>  {
>>         return -1;
>>  }
>>
>>
>> -static iw_handler r8192_wx_handlers[] =
>> -{
>> +static iw_handler r8192_wx_handlers[] = {
>>         NULL,                     /* SIOCSIWCOMMIT */
>>         r8192_wx_get_name,        /* SIOCGIWNAME */
>>         dummy,                    /* SIOCSIWNWID */
>> @@ -913,13 +929,13 @@ static iw_handler r8192_wx_handlers[] =
>>         r8192_wx_get_power,                    /* SIOCGIWPOWER */
>>         NULL,                   /*---hole---*/
>>         NULL,                   /*---hole---*/
>> -       r8192_wx_set_gen_ie,//NULL,                     /* SIOCSIWGENIE */
>> +       r8192_wx_set_gen_ie,/*NULL, */                  /* SIOCSIWGENIE */
>>         NULL,                   /* SIOCSIWGENIE */
>>
>> -       r8192_wx_set_auth,//NULL,                       /* SIOCSIWAUTH */
>> -       NULL,//r8192_wx_get_auth,//NULL,                        /* SIOCSIWAUTH */
>> +       r8192_wx_set_auth,/*NULL, */                    /* SIOCSIWAUTH */
>> +       NULL,/*r8192_wx_get_auth,*//*NULL,*/                    /* SIOCSIWAUTH */
>>         r8192_wx_set_enc_ext,                   /* SIOCSIWENCODEEXT */
>> -       NULL,//r8192_wx_get_enc_ext,//NULL,                     /* SIOCSIWENCODEEXT */
>> +       NULL,/*r8192_wx_get_enc_ext,*//*NULL,*/                 /* SIOCSIWENCODEEXT */
>>         NULL,                   /* SIOCSIWPMKSA */
>>         NULL,                    /*---hole---*/
>>
>> @@ -952,27 +968,26 @@ static const struct iw_priv_args r8192_private_args[] = {
>>
>>
>>  static iw_handler r8192_private_handler[] = {
>> -//     r8192_wx_set_monitor,  /* SIOCIWFIRSTPRIV */
>> +/*     r8192_wx_set_monitor, *//* SIOCIWFIRSTPRIV */
>>         r8192_wx_set_crcmon,   /*SIOCIWSECONDPRIV*/
>> -//     r8192_wx_set_forceassociate,
>> -//     r8192_wx_set_beaconinterval,
>> -//     r8192_wx_set_monitor_type,
>> +/*     r8192_wx_set_forceassociate, */
>> +/*     r8192_wx_set_beaconinterval, */
>> +/*     r8192_wx_set_monitor_type, */
>>         r8192_wx_set_scan_type,
>>         r8192_wx_set_rawtx,
>> -       //r8192_wx_null,
>> +       /*r8192_wx_null, */
>>         r8192_wx_force_reset,
>>  };
>>
>>  struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
>>  {
>> -       struct r8192_priv *priv = ieee80211_priv(dev);
>> +       struct r8192_priv *priv = ieee80211_priv(dev);
>>         struct ieee80211_device *ieee = priv->ieee80211;
>>         struct iw_statistics *wstats = &priv->wstats;
>>         int tmp_level = 0;
>>         int tmp_qual = 0;
>>         int tmp_noise = 0;
>> -       if(ieee->state < IEEE80211_LINKED)
>> -       {
>> +       if (ieee->state < IEEE80211_LINKED) {
>>                 wstats->qual.qual = 0;
>>                 wstats->qual.level = 0;
>>                 wstats->qual.noise = 0;
>> @@ -980,20 +995,20 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
>>                 return wstats;
>>         }
>>
>> -       tmp_level = (&ieee->current_network)->stats.rssi;
>> +       tmp_level = (&ieee->current_network)->stats.rssi;
>>         tmp_qual = (&ieee->current_network)->stats.signal;
>>         tmp_noise = (&ieee->current_network)->stats.noise;
>> -       //printk("level:%d, qual:%d, noise:%d\n", tmp_level, tmp_qual, tmp_noise);
>> +       /*printk("level:%d, qual:%d, noise:%d\n", tmp_level, tmp_qual, tmp_noise); */
>>
>>         wstats->qual.level = tmp_level;
>>         wstats->qual.qual = tmp_qual;
>>         wstats->qual.noise = tmp_noise;
>> -       wstats->qual.updated = IW_QUAL_ALL_UPDATED| IW_QUAL_DBM;
>> +       wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
>>         return wstats;
>>  }
>>
>>
>> -struct iw_handler_def  r8192_wx_handlers_def={
>> +struct iw_handler_def  r8192_wx_handlers_def = {
>>         .standard = r8192_wx_handlers,
>>         .num_standard = ARRAY_SIZE(r8192_wx_handlers),
>>         .private = r8192_private_handler,
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
