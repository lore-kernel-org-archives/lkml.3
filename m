Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbaD3Mjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:39:53 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:49580 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757058AbaD3Mjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:39:52 -0400
Message-ID: <1398861590.18460.7.camel@x220>
Subject: Re: [PATCH] [linux-next] [staging] rtl8821ae: fixed
 defined-not-used warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Jan Moskyto Matejka <mq@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark@einon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Apr 2014 14:39:50 +0200
In-Reply-To: <1398860143-2676-1-git-send-email-mq@suse.cz>
References: <1398860143-2676-1-git-send-email-mq@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Apr 2014 12:39:50.0574 (UTC) FILETIME=[473484E0:01CF6471]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 14:15 +0200, Jan Moskyto Matejka wrote:
> --- a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
> +++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
> @@ -503,6 +503,7 @@ static void halbtc8192e2ant_querybt_info(struct btc_coexist *btcoexist)
>  	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
>  }
>  
> +#if (BT_AUTO_REPORT_ONLY_8192E_2ANT != 0)
>  static bool halbtc8192e2ant_iswifi_status_changed(struct btc_coexist *btcoexist)
>  {
>  	static bool pre_wifi_busy;
> @@ -534,6 +535,7 @@ static bool halbtc8192e2ant_iswifi_status_changed(struct btc_coexist *btcoexist)
>  
>  	return false;
>  }
> +#endif
>  
>  static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btcoexist)
>  {

The output of 
    git grep BT_AUTO_REPORT_ONLY_8192E_2ANT next-20140430

is
    next-20140430:drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c:#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 1)
    next-20140430:drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c:#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
    next-20140430:drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c:#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
    next-20140430:drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h:#define     BT_AUTO_REPORT_ONLY_8192E_2ANT                  0

So it seems that some trivial cleaning up is possible. Ie, drop the
#define and drop the three tests that are either always true or always
false. Is there a reason not to do that cleaning up?


Paul Bolle

