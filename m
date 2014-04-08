Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaDHATU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 20:19:20 -0400
Received: from nm4-vm1.bullet.mail.ir2.yahoo.com ([212.82.96.99]:20222 "EHLO
	nm4-vm1.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174AbaDHATS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 20:19:18 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Apr 2014 20:19:18 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 964269.10413.bm@omp1054.mail.ir2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-RocketYMMF:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ZhaimUJCZ7NansbQ1RK/ER3RqEcoQRsa2QIN4VgK9FOeSsCATHSbLUEib3YJ4fxTzQY4VqIYDKRolThTZQBPttvjvBsXHg1kOkinn5ziMDMdGpmmlbPvCg582jE1EGvgyJGy4dKZRxZmbFlUooeop75bsZtgcBaGkbRU4cIJ7fE=;
X-YMail-OSG: i0guXa0VM1mhom0MpjaQ9._4_bYFN9XkCywFo_lX1zVUn0j
 8KdeU99wnsmEDp1wwQFIKzKoy8OuOf9BmF5IbhKMN4KcCXf8kRuuUTltSsmt
 uNkdLcsF3SV7SZxaqpDgnF4W.QCf3Yals3VjJkL7RWzBpM24Po5f04HpfnoA
 SAdWzEiPL3zrPZ3DU37kGqF9uWWmGUbo7iCjzekNTh490GPjZaknYFlCK_dX
 xArsAcLCBJfAK1I41ZCW5YJMhT5wjto1OpaDuwgo5H_ixnjby4RK_UFs5wuq
 3dAZIkbp5tfLxmeJ7HYRVZ10MyuqsIrgE96XVKlgNZsvTblNVwGFljR4a0UB
 dsW8YMvMVEODA89G6iRR.Vc_AHwsJmsILUh0ktURyp4LyuE8GqiNR.xskmTb
 hCtyHmj_mGV2i_91OYnddgpdJlvI5PcZ8Gw_C84pIdF0nLQSZGAd9O182MJU
 TToSZ.DXCwLwPYvyZ_2E2uCkTV.itj7jrqHOs68OXnxIldT.Ge4s_I1mOis1
 JxgdJYGROx6K0jjdZGA1dVHtGtR1S8oGu9LklACFCAScmzZ.pS5e.P_W1le3
 aI6fpTUfN3GaUmdv_fo.GdfTfzKnlLh1ebCFuzIRSLpd6XfOUtGtqibdazGo
 M8MyqmVmr
X-Rocket-MIMEInfo: 002.001,LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpPbiBTdW4sIE1hciAzMCwgMjAxNCAxMDozMSBQTSBCU1QgTGFycnkgRmluZ2VyIHdyb3RlOg0KDQo.T24gMDMvMjgvMjAxNCAwMzoyNiBQTSwgQWxleGV5IEtob3Jvc2hpbG92IHdyb3RlOg0KPiBJZiBhbGxvY2F0aW9uIG9mIGlvX2RtYWJ1ZiBmYWlscywgcnRsODE4N19wcm9iZSgpIGNhbGxzIHVzYl9wdXRfZGV2KHVkZXYpDQo.IHdoaWxlIHVzYl9nZXRfZGV2KHVkZXYpIGlzIG5vdCBjYWxsZWQgeWV0LiBBcyBhIHJlc3VsdCByZWZjbnQgaXMgZGVjcmUBMAEBAQE-
X-RocketYMMF: hintak_leung
X-Mailer: YahooMailClassic/481 YahooMailWebService/0.8.182.648
Message-ID: <1396915964.55973.YahooMailBasic@web172301.mail.ir2.yahoo.com>
Date: Tue, 8 Apr 2014 01:12:44 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: fix use after free on failure path in rtl8187_probe()
To: larry.finger@lwfinger.net, khoroshilov@ispras.ru, herton@canonical.com
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
On Sun, Mar 30, 2014 10:31 PM BST Larry Finger wrote:

>On 03/28/2014 03:26 PM, Alexey Khoroshilov wrote:
> If allocation of io_dmabuf fails, rtl8187_probe() calls usb_put_dev(udev)
> while usb_get_dev(udev) is not called yet. As a result refcnt is decremented
> incorrectly and usb_dev can be used after memory deallocation.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>
>Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>
>Thanks,
>
>Larry

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Hin-Tak

>
>   drivers/net/wireless/rtl818x/rtl8187/dev.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
> index fd78df813a85..d7f540a9dc9b 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
> @@ -1636,10 +1636,10 @@ static int rtl8187_probe(struct usb_interface *intf,
>
>    err_free_dmabuf:
>       kfree(priv->io_dmabuf);
> - err_free_dev:
> -    ieee80211_free_hw(dev);
>       usb_set_intfdata(intf, NULL);
>       usb_put_dev(udev);
> + err_free_dev:
> +    ieee80211_free_hw(dev);
>       return err;
>   }
>
>
>


