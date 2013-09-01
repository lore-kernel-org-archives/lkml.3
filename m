Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3IAHvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 03:51:24 -0400
Received: from nm12-vm0.bullet.mail.ird.yahoo.com ([77.238.189.196]:45221 "HELO
	nm12-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753128Ab3IAHvW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 03:51:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 306292.92321.bm@omp1012.mail.ir2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-RocketYMMF:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ynSrzr+UglIwLT/I9n3b5VVHDR6lcwFDqjJiBzlICHFDIXTB+1c77p98ZjR0IpvfXlPBfrQBP1rJUdF0tTryzqCR6bb9cjReydedwr3/Fcx+mx8Qoy1VB7YNSxsxGcaimwobEm/N5orBE3ilQReggv8GjFhbdbOa81BoF9uXAFo=;
X-YMail-OSG: VYBhtXkVM1kURkQJ7BQXAKtKGrzcUzmGtfUT3ijVGoxWFnP
 I7vQIWlYRMWj3oXyfECUA7Vqqg7q4Os7yEypHTkJGdYiEW0JVUm7kSfIIqTv
 5qqhAnpZwKdHP2mgcPdaSxYI.HVgqZcZOxglKMor2lUn_sNDRbxvyTLStS8Q
 kFJUz_49jBPgIH3eLLs2oh02IWgDlohgszB7n9t4WUudJq3hGCwMa1RKJE8v
 axqVnNzNsUlcXSivll2i.31d_CVTGOOlSOGStCLwGbiEkcPUL4Ips7rnpzF4
 FxeTDTeMb3CFa5y7aZE8Rm3qJpBGDPPql8k_M0X.KJCzpnEGVFOwy3ThkHo5
 1Ai3x6Cb8bJ1iYfkTrmUMScSgtm6Ws2HOvtYMrXnNmrAyuRY8SqQoPjXI4HK
 0Nh2qlF2vGYFNxFM9HmGNs9L4sguBB.u7BgIlFaxlsaS1tHB8kzCMjBbRnok
 YRLkh82vpXOvs.C49.R.NS4U0cBScqm3OilhwtDRrgqYC96JmgZ005j8rafw
 TiXYKIVNi5labfzdmuYFJomaVYzKgynEt5OTZu_HjEQPYx8aZI5BPLT3ufX_
 igRymk1TOEA_5qGDlg7EIVVxs_hRpFmLVnPbYwaAmmvVfeH57huCeFapbgQI
 YDj5UauY-
X-Rocket-MIMEInfo: 002.001,LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpPbiBTYXQsIEF1ZyAzMSwgMjAxMyAyMjoxOCBCU1QgQWxleGV5IEtob3Jvc2hpbG92IHdyb3RlOg0KDQo.SW4gY2FzZSBvZiBfX2Rldl9hbGxvY19za2IoKSBmYWlsdXJlIHJ0bDgxODdfaW5pdF91cmJzKCkNCj5jYWxscyB1c2JfZnJlZV91cmIoZW50cnkpIHdoZXJlICdlbnRyeScgY2FuIHBvaW50cyB0byB1cmINCj5hbGxvY2F0ZWQgYXQgdGhlIHByZXZpb3VzIGl0ZXJhdGlvbi4gVGhhdCBtZWFucyByZWZjbnQgd2lsbCBiZQ0KPmRlY3JlbWVudGVkIGkBMAEBAQE-
X-RocketYMMF: hintak_leung
X-Mailer: YahooMailClassic/315 YahooMailWebService/0.8.156.576
Message-ID: <1378021881.73447.YahooMailBasic@web172302.mail.ir2.yahoo.com>
Date: Sun, 1 Sep 2013 08:51:21 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: fix use after free on failure path in rtl8187_init_urbs()
To: khoroshilov@ispras.ru, herton@canonical.com, larry.finger@lwfinger.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------------------------
On Sat, Aug 31, 2013 22:18 BST Alexey Khoroshilov wrote:

>In case of __dev_alloc_skb() failure rtl8187_init_urbs()
>calls usb_free_urb(entry) where 'entry' can points to urb
>allocated at the previous iteration. That means refcnt will be
>decremented incorrectly and the urb can be used after memory
>deallocation.
>
>The patch fixes the issue and implements error handling of init_urbs
>in rtl8187_start().
>
>Found by Linux Driver Verification project (linuxtesting.org).
>
>Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>---
> drivers/net/wireless/rtl818x/rtl8187/dev.c | 15 ++++++++++-----
> 1 file changed, 10 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>index f49220e..e83d53c 100644
>--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
>+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>@@ -438,17 +438,16 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
>         skb_queue_tail(&priv->rx_queue, skb);
>         usb_anchor_urb(entry, &priv->anchored);
>         ret = usb_submit_urb(entry, GFP_KERNEL);
>+        usb_free_urb(entry);
>         if (ret) {
>             skb_unlink(skb, &priv->rx_queue);
>             usb_unanchor_urb(entry);
>             goto err;
>         }
>-        usb_free_urb(entry);
>     }
>     return ret;
>
> err:
>-    usb_free_urb(entry);
>     kfree_skb(skb);
>     usb_kill_anchored_urbs(&priv->anchored);
>     return ret;

This part looks wrong - you free_urb(entry) then unanchor_urb(entry).

>@@ -956,8 +955,12 @@ static int rtl8187_start(struct ieee80211_hw *dev)
>                   (RETRY_COUNT < 8  /* short retry limit */) |
>                   (RETRY_COUNT < 0  /* long retry limit */) |
>                   (7 < 21 /* MAX TX DMA */));
>-        rtl8187_init_urbs(dev);
>-        rtl8187b_init_status_urb(dev);
>+        ret = rtl8187_init_urbs(dev);
>+        if (ret)
>+            goto rtl8187_start_exit;
>+        ret = rtl8187b_init_status_urb(dev);
>+        if (ret)
>+            usb_kill_anchored_urbs(&priv->anchored);
>         goto rtl8187_start_exit;
>     }
> 
>@@ -966,7 +969,9 @@ static int rtl8187_start(struct ieee80211_hw *dev)
>     rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
>     rtl818x_iowrite32(priv, &priv->map->MAR[1], ~0);
> 
>-    rtl8187_init_urbs(dev);
>+    ret = rtl8187_init_urbs(dev);
>+    if (ret)
>+        goto rtl8187_start_exit;
> 
>     reg = RTL818X_RX_CONF_ONLYERLPKT |
>           RTL818X_RX_CONF_RX_AUTORESETPHY |
>-- 
>1.8.1.2
>


