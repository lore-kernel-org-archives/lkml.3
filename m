Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaDONBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:01:17 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:43172 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDONBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:01:14 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Sathya Perla <Sathya.Perla@Emulex.Com>
CC: Subramanian Seetharaman <subbu.seetharaman@Emulex.Com>,
        Ajit Khaparde <Ajit.Khaparde@Emulex.Com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] driver/net: add missing rtnl lock/unlock for benet
Thread-Topic: [PATCH 1/1] driver/net: add missing rtnl lock/unlock for benet
Thread-Index: AQHPWHZzB4ZhiqSvOE2g6A6YjGbZ5psSUqiAgAAPNACAADEFgIAAEWW/
Date: Tue, 15 Apr 2014 12:59:56 +0000
Message-ID: <1249C41B-D72F-40C8-A8F1-D135D02A1511@hp.com>
References: <1397544352-28841-1-git-send-email-zhen-hual@hp.com>
 <b4855c2a-5a63-47a5-ba61-f9ce736f6401@CMEXHTCAS1.ad.emulex.com>
 <534CF596.3010609@hp.com>,<069bdb52-6176-407a-b7fc-3f23a944a529@CMEXHTCAS2.ad.emulex.com>
In-Reply-To: <069bdb52-6176-407a-b7fc-3f23a944a529@CMEXHTCAS2.ad.emulex.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3FD1Sbv027239

Yes, that's ok for me.

·¢×ÔÎÒµÄ iPhone

ÔÚ 2014Äê4ÔÂ15ÈÕ£¬ÏÂÎç7:57£¬"Sathya Perla" <Sathya.Perla@Emulex.Com> Ğ´µÀ£º

>> -----Original Message-----
>> From: Li, ZhenHua [mailto:zhen-hual@hp.com]
>> 
>> Because netif_running() is called in netif_device_detach and
>> netif_device_attach. To avoid dev status changed while
>> netif_device_detach/attach is not finished, I think a rtnl_lock and
>> unlock should be called to avoid this.
> 
> Ok. I'd like to then factor the code slightly differently by using
> routines like this:
> 
> be_close_sync() {
>    rtnl_lock();
> 
>      netif_device_detach(netdev);
>       if (netif_running(netdev))
>           be_close(netdev);
> 
>    rtnl_unlock();
> }
> 
> and similarly for be_open_sync()
> 
> And, I'd need some time to test these flows too.
> Would you be OK with this?
> 
> thanks,
> -Sathya
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
