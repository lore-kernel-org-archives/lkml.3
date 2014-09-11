Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaIKKgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:36:47 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:45928 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaIKKgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:36:45 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "dsd@gentoo.org" <dsd@gentoo.org>,
        "kune@deine-taler.de" <kune@deine-taler.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] zd1211rw: replace ZD_ASSERT with
 lockdep_assert_held()
Thread-Topic: [PATCH v2] zd1211rw: replace ZD_ASSERT with
 lockdep_assert_held()
Thread-Index: AQHPzaji67ru1uysWEKojhy3lQjAn5v7vMNQ
Date: Thu, 11 Sep 2014 10:36:42 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF5256D@EU-MBX-02.mgc.mentorg.com>
References: <1410418407.1825.0.camel@jlt4.sipsolutions.net>
	 <1410430179-19944-1-git-send-email-sanjeev_sharma@mentor.com>
	 (sfid-20140911_121019_335368_163BEA7C)
 <1410430345.22863.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1410430345.22863.0.camel@jlt4.sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8BAapus023169

-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Thursday, September 11, 2014 3:42 PM
To: Sharma, Sanjeev
Cc: dsd@gentoo.org; kune@deine-taler.de; linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org; netdev@vger.kernel.org
Subject: Re: [PATCH v2] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()

On Thu, 2014-09-11 at 15:39 +0530, Sanjeev Sharma wrote:
> on some architecture spin_is_locked() always return false in 
> uniprocessor configuration and therefore it would be advise to replace 
> with lockdep_assert_held().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
> Changes in v2:
>   - corrected the typo

> Now it compiles, but you got the logic wrong.

> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -235,7 +235,7 @@ void zd_mac_clear(struct zd_mac *mac)  {
>  	flush_workqueue(zd_workqueue);
>  	zd_chip_clear(&mac->chip);
> -	ZD_ASSERT(!spin_is_locked(&mac->lock));
> +	lockdep_assert_held(&mac->lock);
>  	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));  }

>Look closely at this again.

I didn't understand where I  put wrong logic  ?

Regards
Sanjeev Sharma

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
