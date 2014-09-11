Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaIKW1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:27:43 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:43860 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaIKW1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:27:40 -0400
MIME-Version: 1.0
Date: Thu, 11 Sep 2014 15:27:39 -0700
X-Google-Sender-Auth: icMjShJTF652rHZ1XWeHOIU_YHQ
Message-ID: <CAGXu5j+kh3TTR8yiyH35mXUo91g5a-ULS6w2CvKzGmQ4UuL-aA@mail.gmail.com>
Subject: repeated bugs in new rtl wifi drivers
From: Kees Cook <keescook@chromium.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I keep fixing this same bug that keeps showing up in the rtl wifi
drivers. CL_PRINTF keeps getting redefined (incorrectly) instead of
using a correctly fixed global. Is there a way to stop this from
happening again?

Here are the past three (identical) fixes I've landed:
a3355a62673e2c4bd8617d2f07c8edee92a89b8d
037526f1ae7eeff5cf27ad790ebfe30303eeebe8
6437f51ec36af8ef1e3e2659439b35c37e5498e2

And the buildbot report below seems to show there are more to be made. :)

-Kees


On Thu, Sep 11, 2014 at 3:18 PM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> Hi Wu,
>
> FYI, this happens on a merge commit, which indicates conflicting changes with one of the below merged branches.
>
> d945102 Merge 'kees/format-security' into devel-ivytown2-arm-201409120526
> c742d38 Merge 'kees/arm/ro-nx' into devel-ivytown2-arm-201409120526
> ec97758 Merge 'ath6kl/master' into devel-ivytown2-arm-201409120526
> 48f33be9 Merge 'ath6kl/ath-qca' into devel-ivytown2-arm-201409120526
> a61d602 Merge 'ath6kl/ath-next' into devel-ivytown2-arm-201409120526
> 6dbaa59 Merge 'amirv/for-netdev' into devel-ivytown2-arm-201409120526
> f69cf24 0day base guard for 'devel-ivytown2-arm-201409120526'
> 2ce7598 Linux 3.17-rc4
>
>
> tree:   git://internal_merge_and_test_tree devel-ivytown2-arm-201409120526
> head:   12d400c1ef6548027cd38a56adcd29c256686b99
> commit: d9451023b919c2c709b8351f7cce8e9dea48d82b [7/35] Merge 'kees/format-security' into devel-ivytown2-arm-201409120526
> config: arm-allmodconfig
> reproduce:
>   wget https://github.com/fengguang/reproduce-kernel-bug/raw/master/cross-build/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout d9451023b919c2c709b8351f7cce8e9dea48d82b
>   make.cross ARCH=arm  allmodconfig
>   make.cross ARCH=arm
>
> All error/warnings:
>
>    drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c: In function 'ex_btc8723b2ant_display_coex_info':
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3176:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3181:3: error: format not a string literal and no format arguments [-Werror=format-security]
>       CL_PRINTF(cli_buf);
>       ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3184:3: error: format not a string literal and no format arguments [-Werror=format-security]
>       CL_PRINTF(cli_buf);
>       ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3189:3: error: format not a string literal and no format arguments [-Werror=format-security]
>       CL_PRINTF(cli_buf);
>       ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3196:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3202:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3211:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3221:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3226:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3233:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3240:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3254:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3256:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3262:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3269:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3285:4: error: format not a string literal and no format arguments [-Werror=format-security]
>        CL_PRINTF(cli_buf);
>        ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3293:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3299:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3303:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>>> drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c:3308:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      CL_PRINTF(cli_buf);
>      ^
>
> vim +3176 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c
>
> aa45a673 Larry Finger 2014-02-28  3170          u8 wifi_dot11_chnl, wifi_hs_chnl;
> aa45a673 Larry Finger 2014-02-28  3171          u32 fw_ver = 0, bt_patch_ver = 0;
> e79fff28 Larry Finger 2014-09-04  3172          u8 ap_num = 0;
> aa45a673 Larry Finger 2014-02-28  3173
> aa45a673 Larry Finger 2014-02-28  3174          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
> aa45a673 Larry Finger 2014-02-28  3175                     "\r\n ============[BT Coexist info]============");
> aa45a673 Larry Finger 2014-02-28  3176          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3177
> aa45a673 Larry Finger 2014-02-28  3178          if (btcoexist->manual_control) {
> aa45a673 Larry Finger 2014-02-28  3179                  CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
> aa45a673 Larry Finger 2014-02-28  3180                             "\r\n ==========[Under Manual Control]============");
> aa45a673 Larry Finger 2014-02-28  3181                  CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3182                  CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
> aa45a673 Larry Finger 2014-02-28  3183                             "\r\n ==========================================");
> aa45a673 Larry Finger 2014-02-28  3184                  CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3185          }
> aa45a673 Larry Finger 2014-02-28  3186
> aa45a673 Larry Finger 2014-02-28  3187          if (!board_info->bt_exist) {
> aa45a673 Larry Finger 2014-02-28  3188                  CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n BT not exists !!!");
> aa45a673 Larry Finger 2014-02-28  3189                  CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3190                  return;
> aa45a673 Larry Finger 2014-02-28  3191          }
> aa45a673 Larry Finger 2014-02-28  3192
> aa45a673 Larry Finger 2014-02-28  3193          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d ",
> aa45a673 Larry Finger 2014-02-28  3194                     "Ant PG number/ Ant mechanism:",
> aa45a673 Larry Finger 2014-02-28  3195                     board_info->pg_ant_num, board_info->btdm_ant_num);
> aa45a673 Larry Finger 2014-02-28  3196          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3197
> aa45a673 Larry Finger 2014-02-28  3198          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %d",
> aa45a673 Larry Finger 2014-02-28  3199                     "BT stack/ hci ext ver",
> aa45a673 Larry Finger 2014-02-28  3200                     ((stack_info->profile_notified) ? "Yes" : "No"),
> aa45a673 Larry Finger 2014-02-28  3201                     stack_info->hci_version);
> aa45a673 Larry Finger 2014-02-28  3202          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3203
> aa45a673 Larry Finger 2014-02-28  3204          btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER, &bt_patch_ver);
> aa45a673 Larry Finger 2014-02-28  3205          btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
> aa45a673 Larry Finger 2014-02-28  3206          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
> aa45a673 Larry Finger 2014-02-28  3207                     "\r\n %-35s = %d_%x/ 0x%x/ 0x%x(%d)",
> aa45a673 Larry Finger 2014-02-28  3208                     "CoexVer/ FwVer/ PatchVer",
> aa45a673 Larry Finger 2014-02-28  3209                     glcoex_ver_date_8723b_2ant, glcoex_ver_8723b_2ant,
> aa45a673 Larry Finger 2014-02-28  3210                     fw_ver, bt_patch_ver, bt_patch_ver);
> aa45a673 Larry Finger 2014-02-28  3211          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3212
> aa45a673 Larry Finger 2014-02-28  3213          btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
> aa45a673 Larry Finger 2014-02-28  3214          btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_DOT11_CHNL,
> aa45a673 Larry Finger 2014-02-28  3215                             &wifi_dot11_chnl);
> aa45a673 Larry Finger 2014-02-28  3216          btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_HS_CHNL, &wifi_hs_chnl);
> aa45a673 Larry Finger 2014-02-28  3217
> aa45a673 Larry Finger 2014-02-28  3218          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d / %d(%d)",
> aa45a673 Larry Finger 2014-02-28  3219                     "Dot11 channel / HsChnl(HsMode)",
> aa45a673 Larry Finger 2014-02-28  3220                     wifi_dot11_chnl, wifi_hs_chnl, bt_hs_on);
> aa45a673 Larry Finger 2014-02-28  3221          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3222
> aa45a673 Larry Finger 2014-02-28  3223          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %02x %02x %02x ",
> aa45a673 Larry Finger 2014-02-28  3224                     "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info[0],
> aa45a673 Larry Finger 2014-02-28  3225                     coex_dm->wifi_chnl_info[1], coex_dm->wifi_chnl_info[2]);
> aa45a673 Larry Finger 2014-02-28  3226          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3227
> aa45a673 Larry Finger 2014-02-28  3228          btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
> aa45a673 Larry Finger 2014-02-28  3229          btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
> e79fff28 Larry Finger 2014-09-04  3230          btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
> e79fff28 Larry Finger 2014-09-04  3231          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d",
> e79fff28 Larry Finger 2014-09-04  3232                     "Wifi rssi/ HS rssi/ AP#", wifi_rssi, bt_hs_rssi, ap_num);
> aa45a673 Larry Finger 2014-02-28  3233          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3234
> aa45a673 Larry Finger 2014-02-28  3235          btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
> aa45a673 Larry Finger 2014-02-28  3236          btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
> aa45a673 Larry Finger 2014-02-28  3237          btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
> aa45a673 Larry Finger 2014-02-28  3238          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d ",
> aa45a673 Larry Finger 2014-02-28  3239                     "Wifi link/ roam/ scan", link, roam, scan);
> aa45a673 Larry Finger 2014-02-28  3240          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3241
> aa45a673 Larry Finger 2014-02-28  3242          btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
> aa45a673 Larry Finger 2014-02-28  3243          btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
> aa45a673 Larry Finger 2014-02-28  3244          btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
> aa45a673 Larry Finger 2014-02-28  3245          btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION,
> aa45a673 Larry Finger 2014-02-28  3246                             &wifi_traffic_dir);
> aa45a673 Larry Finger 2014-02-28  3247          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %s/ %s ",
> aa45a673 Larry Finger 2014-02-28  3248                     "Wifi status", (wifi_under_5g ? "5G" : "2.4G"),
> aa45a673 Larry Finger 2014-02-28  3249                     ((BTC_WIFI_BW_LEGACY == wifi_bw) ? "Legacy" :
> aa45a673 Larry Finger 2014-02-28  3250                     (((BTC_WIFI_BW_HT40 == wifi_bw) ? "HT40" : "HT20"))),
> aa45a673 Larry Finger 2014-02-28  3251                     ((!wifi_busy) ? "idle" :
> aa45a673 Larry Finger 2014-02-28  3252                     ((BTC_WIFI_TRAFFIC_TX == wifi_traffic_dir) ?
> aa45a673 Larry Finger 2014-02-28  3253                     "uplink" : "downlink")));
> aa45a673 Larry Finger 2014-02-28  3254          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3255
> aa45a673 Larry Finger 2014-02-28  3256          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3257
> aa45a673 Larry Finger 2014-02-28  3258          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d / %d / %d / %d",
> aa45a673 Larry Finger 2014-02-28  3259                     "SCO/HID/PAN/A2DP",
> aa45a673 Larry Finger 2014-02-28  3260                     bt_link_info->sco_exist, bt_link_info->hid_exist,
> aa45a673 Larry Finger 2014-02-28  3261                     bt_link_info->pan_exist, bt_link_info->a2dp_exist);
> aa45a673 Larry Finger 2014-02-28  3262          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3263          btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_BT_LINK_INFO);
> aa45a673 Larry Finger 2014-02-28  3264
> aa45a673 Larry Finger 2014-02-28  3265          bt_info_ext = coex_sta->bt_info_ext;
> aa45a673 Larry Finger 2014-02-28  3266          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s",
> aa45a673 Larry Finger 2014-02-28  3267                     "BT Info A2DP rate",
> aa45a673 Larry Finger 2014-02-28  3268                     (bt_info_ext&BIT0) ? "Basic rate" : "EDR rate");
> aa45a673 Larry Finger 2014-02-28  3269          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3270
> aa45a673 Larry Finger 2014-02-28  3271          for (i = 0; i < BT_INFO_SRC_8723B_2ANT_MAX; i++) {
> aa45a673 Larry Finger 2014-02-28  3272                  if (coex_sta->bt_info_c2h_cnt[i]) {
> aa45a673 Larry Finger 2014-02-28  3273                          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
> aa45a673 Larry Finger 2014-02-28  3274                                     "\r\n %-35s = %02x %02x %02x "
> aa45a673 Larry Finger 2014-02-28  3275                                     "%02x %02x %02x %02x(%d)",
> aa45a673 Larry Finger 2014-02-28  3276                                     glbt_info_src_8723b_2ant[i],
> aa45a673 Larry Finger 2014-02-28  3277                                     coex_sta->bt_info_c2h[i][0],
> aa45a673 Larry Finger 2014-02-28  3278                                     coex_sta->bt_info_c2h[i][1],
> aa45a673 Larry Finger 2014-02-28  3279                                     coex_sta->bt_info_c2h[i][2],
> aa45a673 Larry Finger 2014-02-28  3280                                     coex_sta->bt_info_c2h[i][3],
> aa45a673 Larry Finger 2014-02-28  3281                                     coex_sta->bt_info_c2h[i][4],
> aa45a673 Larry Finger 2014-02-28  3282                                     coex_sta->bt_info_c2h[i][5],
> aa45a673 Larry Finger 2014-02-28  3283                                     coex_sta->bt_info_c2h[i][6],
> aa45a673 Larry Finger 2014-02-28  3284                                     coex_sta->bt_info_c2h_cnt[i]);
> aa45a673 Larry Finger 2014-02-28  3285                          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3286                  }
> aa45a673 Larry Finger 2014-02-28  3287          }
> aa45a673 Larry Finger 2014-02-28  3288
> aa45a673 Larry Finger 2014-02-28  3289          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s/%s",
> aa45a673 Larry Finger 2014-02-28  3290                     "PS state, IPS/LPS",
> aa45a673 Larry Finger 2014-02-28  3291                     ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
> aa45a673 Larry Finger 2014-02-28  3292                     ((coex_sta->under_lps ? "LPS ON" : "LPS OFF")));
> aa45a673 Larry Finger 2014-02-28  3293          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3294          btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_FW_PWR_MODE_CMD);
> aa45a673 Larry Finger 2014-02-28  3295
> aa45a673 Larry Finger 2014-02-28  3296          /* Sw mechanism */
> aa45a673 Larry Finger 2014-02-28  3297          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
> aa45a673 Larry Finger 2014-02-28  3298                     "\r\n %-35s", "============[Sw mechanism]============");
> aa45a673 Larry Finger 2014-02-28  3299          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3300          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d ",
> aa45a673 Larry Finger 2014-02-28  3301                     "SM1[ShRf/ LpRA/ LimDig]", coex_dm->cur_rf_rx_lpf_shrink,
> aa45a673 Larry Finger 2014-02-28  3302                     coex_dm->cur_low_penalty_ra, coex_dm->limited_dig);
> aa45a673 Larry Finger 2014-02-28  3303          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3304          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d(0x%x) ",
> aa45a673 Larry Finger 2014-02-28  3305                     "SM2[AgcT/ AdcB/ SwDacSwing(lvl)]",
> aa45a673 Larry Finger 2014-02-28  3306                     coex_dm->cur_agc_table_en, coex_dm->cur_adc_back_off,
> aa45a673 Larry Finger 2014-02-28  3307                     coex_dm->cur_dac_swing_on, coex_dm->cur_dac_swing_lvl);
> aa45a673 Larry Finger 2014-02-28  3308          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3309
> aa45a673 Larry Finger 2014-02-28  3310          /* Fw mechanism */
> aa45a673 Larry Finger 2014-02-28  3311          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
> aa45a673 Larry Finger 2014-02-28  3312                     "============[Fw mechanism]============");
> aa45a673 Larry Finger 2014-02-28  3313          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3314
> aa45a673 Larry Finger 2014-02-28  3315          ps_tdma_case = coex_dm->cur_ps_tdma;
> aa45a673 Larry Finger 2014-02-28  3316          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
> aa45a673 Larry Finger 2014-02-28  3317                     "\r\n %-35s = %02x %02x %02x %02x %02x case-%d (auto:%d)",
> aa45a673 Larry Finger 2014-02-28  3318                     "PS TDMA", coex_dm->ps_tdma_para[0],
> aa45a673 Larry Finger 2014-02-28  3319                     coex_dm->ps_tdma_para[1], coex_dm->ps_tdma_para[2],
> aa45a673 Larry Finger 2014-02-28  3320                     coex_dm->ps_tdma_para[3], coex_dm->ps_tdma_para[4],
> aa45a673 Larry Finger 2014-02-28  3321                     ps_tdma_case, coex_dm->auto_tdma_adjust);
> aa45a673 Larry Finger 2014-02-28  3322          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3323
> aa45a673 Larry Finger 2014-02-28  3324          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d ",
> aa45a673 Larry Finger 2014-02-28  3325                     "DecBtPwr/ IgnWlanAct", coex_dm->cur_dec_bt_pwr,
> aa45a673 Larry Finger 2014-02-28  3326                     coex_dm->cur_ignore_wlan_act);
> aa45a673 Larry Finger 2014-02-28  3327          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3328
> aa45a673 Larry Finger 2014-02-28  3329          /* Hw setting */
> aa45a673 Larry Finger 2014-02-28  3330          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
> aa45a673 Larry Finger 2014-02-28  3331                     "============[Hw setting]============");
> aa45a673 Larry Finger 2014-02-28  3332          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3333
> aa45a673 Larry Finger 2014-02-28  3334          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x",
> aa45a673 Larry Finger 2014-02-28  3335                     "RF-A, 0x1e initVal", coex_dm->bt_rf0x1e_backup);
> aa45a673 Larry Finger 2014-02-28  3336          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3337
> aa45a673 Larry Finger 2014-02-28  3338          u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x778);
> aa45a673 Larry Finger 2014-02-28  3339          u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x880);
> aa45a673 Larry Finger 2014-02-28  3340          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x",
> aa45a673 Larry Finger 2014-02-28  3341                     "0x778/0x880[29:25]", u8tmp[0],
> aa45a673 Larry Finger 2014-02-28  3342                     (u32tmp[0]&0x3e000000) >> 25);
> aa45a673 Larry Finger 2014-02-28  3343          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3344
> aa45a673 Larry Finger 2014-02-28  3345          u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x948);
> aa45a673 Larry Finger 2014-02-28  3346          u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x67);
> aa45a673 Larry Finger 2014-02-28  3347          u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x765);
> aa45a673 Larry Finger 2014-02-28  3348          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
> aa45a673 Larry Finger 2014-02-28  3349                     "0x948/ 0x67[5] / 0x765",
> aa45a673 Larry Finger 2014-02-28  3350                     u32tmp[0], ((u8tmp[0]&0x20) >> 5), u8tmp[1]);
> aa45a673 Larry Finger 2014-02-28  3351          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3352
> aa45a673 Larry Finger 2014-02-28  3353          u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x92c);
> aa45a673 Larry Finger 2014-02-28  3354          u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x930);
> aa45a673 Larry Finger 2014-02-28  3355          u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x944);
> aa45a673 Larry Finger 2014-02-28  3356          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
> aa45a673 Larry Finger 2014-02-28  3357                     "0x92c[1:0]/ 0x930[7:0]/0x944[1:0]",
> aa45a673 Larry Finger 2014-02-28  3358                     u32tmp[0]&0x3, u32tmp[1]&0xff, u32tmp[2]&0x3);
> aa45a673 Larry Finger 2014-02-28  3359          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3360
> aa45a673 Larry Finger 2014-02-28  3361          u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x39);
> aa45a673 Larry Finger 2014-02-28  3362          u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x40);
> aa45a673 Larry Finger 2014-02-28  3363          u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x4c);
> aa45a673 Larry Finger 2014-02-28  3364          u8tmp[2] = btcoexist->btc_read_1byte(btcoexist, 0x64);
> aa45a673 Larry Finger 2014-02-28  3365          CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
> aa45a673 Larry Finger 2014-02-28  3366                     "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
> aa45a673 Larry Finger 2014-02-28  3367                     "0x38[11]/0x40/0x4c[24:23]/0x64[0]",
> aa45a673 Larry Finger 2014-02-28  3368                     ((u8tmp[0] & 0x8)>>3), u8tmp[1],
> aa45a673 Larry Finger 2014-02-28  3369                     ((u32tmp[0]&0x01800000)>>23), u8tmp[2]&0x1);
> aa45a673 Larry Finger 2014-02-28  3370          CL_PRINTF(cli_buf);
> aa45a673 Larry Finger 2014-02-28  3371
> aa45a673 Larry Finger 2014-02-28  3372          u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x550);
> aa45a673 Larry Finger 2014-02-28  3373          u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x522);
>
> :::::: The code at line 3176 was first introduced by commit
> :::::: aa45a673b291fd761275493bc15316d79555ed55 rtlwifi: btcoexist: Add new mini driver
>
> :::::: TO: Larry Finger <Larry.Finger@lwfinger.net>
> :::::: CC: John W. Linville <linville@tuxdriver.com>
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation



-- 
Kees Cook
Chrome OS Security
