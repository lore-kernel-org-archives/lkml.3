Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3IBGlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:41:24 -0400
Received: from nm22-vm5.bullet.mail.ird.yahoo.com ([212.82.109.224]:46710 "EHLO
	nm22-vm5.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757181Ab3IBGlX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:41:23 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Sep 2013 02:41:22 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 234962.56624.bm@omp1054.mail.ir2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-RocketYMMF:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pqZnQSJUyINkbdxBjp1E9n12Lzg9Wwfa3Otjx6WYjJ0Dc1x5BoxgCiBgfX80fvA57zxMyXCIjrAKU7GLDc92Xw3G42isRxLBuN2tj20ADQ01vgIb419/S3U8f7mx25KWrA+Grgf2YBQ9ZaDDh/fa66HrqMv12perKd/C+fr730A=;
X-YMail-OSG: E5uWJp0VM1kb.vrSSJjJZai4PblGd.B.G.cKYP7Fm76_xDE
 Fshq5rkfqjn6yM.C8HVqt4rrw5PHJQTvQX.KJaQzWTSmJRD4g.0M9vmN9zqj
 L.Fywxx1EeG0HoP5afja2Y6iYoZugy_SmzXG3eFyffR9Nv85at5g2ykT6PNi
 Z37tlpWUHO9hNTCbtLzVpPtWYYqVAGlno0JBiaMvFS2wJa7ktnCmQw6oWFXa
 sZcCxS_w4DRQhAFpVJTm.UhwN8VG8VQ3hOR2mL65skmLp7nPEUbVUTQyMPqI
 f.N1Y3ZOPA0iO9P9m5DNEtLwaRA6cbSXR1uUpWuKZKgf5H3mOoTY4qdp3Vbf
 VAn5WisimWW.heqlu_ZXD9u1xFr5lDEoVIUZr3VXD9865MgWLONL6m2PIIib
 ojI083g2pVopcnNyfCeojL3ovz0EjjQzsfLcfhJQUb4VdXX01i8wTE_BS40S
 Pkc6fTF.gf2jSMM8ezZjEnw.RyB0hThTVOxQ2J8fRbPgInkb677Oo3jY1WWi
 SLR8ceOxmDeLv2IH4eZLkq.evJcZn2_nYqUqMElBeI7IOxSzMlo0U9FsgTCY
 hetzprG_omv9fDBBAyJCl4D8tUxqksP3sri_utSzpvQ--
X-Rocket-MIMEInfo: 002.001,LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpPbiBNb24sIFNlcCAyLCAyMDEzIDA1OjA2IEJTVCBBbGV4ZXkgS2hvcm9zaGlsb3Ygd3JvdGU6DQoNCj5PbiAwMS4wOS4yMDEzIDEwOjUxLCBIaW4tVGFrIExldW5nIHdyb3RlOg0KPj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo.PiBPbiBTYXQsIEF1ZyAzMSwgMjAxMyAyMjoxOCBCU1QgQWxleGV5IEtob3Jvc2hpbG92IHdyb3RlOg0KPj4NCj4.IEluIGNhc2Ugb2YgX19kZXZfYWxsb2Nfc2tiKCkgZmFpbHVyZSBydGw4MTg3X2luaXRfdXIBMAEBAQE-
X-RocketYMMF: hintak_leung
X-Mailer: YahooMailClassic/315 YahooMailWebService/0.8.156.576
Message-ID: <1378103685.43571.YahooMailBasic@web172301.mail.ir2.yahoo.com>
Date: Mon, 2 Sep 2013 07:34:45 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: fix use after free on failure path in rtl8187_init_urbs()
To: khoroshilov@ispras.ru
Cc: larry.finger@lwfinger.net, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
        gregkh@linuxfoundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------------------------
On Mon, Sep 2, 2013 05:06 BST Alexey Khoroshilov wrote:

>On 01.09.2013 10:51, Hin-Tak Leung wrote:
>> ------------------------------
>> On Sat, Aug 31, 2013 22:18 BST Alexey Khoroshilov wrote:
>>
>> In case of __dev_alloc_skb() failure rtl8187_init_urbs()
>> calls usb_free_urb(entry) where 'entry' can points to urb
>> allocated at the previous iteration. That means refcnt will be
>> decremented incorrectly and the urb can be used after memory
>> deallocation.
>>
>> The patch fixes the issue and implements error handling of init_urbs
>> in rtl8187_start().
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> ---
>> drivers/net/wireless/rtl818x/rtl8187/dev.c | 15 ++++++++++-----
>> 1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>> index f49220e..e83d53c 100644
>> --- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
>> +++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>> @@ -438,17 +438,16 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
>>          skb_queue_tail(&priv->rx_queue, skb);
>>          usb_anchor_urb(entry, &priv->anchored);
>>          ret = usb_submit_urb(entry, GFP_KERNEL);
>> +        usb_free_urb(entry);
>>          if (ret) {
>>              skb_unlink(skb, &priv->rx_queue);
>>              usb_unanchor_urb(entry);
>>              goto err;
>>          }
>> -        usb_free_urb(entry);
>>      }
>>      return ret;
>>
>> err:
>> -    usb_free_urb(entry);
>>      kfree_skb(skb);
>>      usb_kill_anchored_urbs(&priv->anchored);
>>      return ret;
>> This part looks wrong - you free_urb(entry) then unanchor_urb(entry).
>I do not see any problems here.
>usb_free_urb() just decrements refcnt of the urb.
>While usb_anchor_urb() and usb_unanchor_urb() increment and decrement it 
>as well.
>So actual memory deallocation will happen in usb_unanchor_urb().

If the routines work as you say, they probably are misnamed, and/or prototyped wrongly?
Also, you are making assumptions about how they are implemented, and relying
on the implementation details to be fixed for eternity.

I am just saying,

XXX_free(some_entity);
if(condtion)
     do_stuff(some_entity);

looks wrong, and if that's intentional, those routines really shouldn't be named as such.

Hin-Tak



