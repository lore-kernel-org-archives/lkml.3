Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3HVKZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:25:02 -0400
Received: from m12-17.163.com ([220.181.12.17]:60002 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab3HVKY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:24:59 -0400
Date: Thu, 22 Aug 2013 17:23:23 +0800
From: "=?utf-8?B?bGl1anVubGlhbmdfbGps?=" <liujunliang_ljl@163.com>
To: "=?utf-8?B?Sm9lIFBlcmNoZXM=?=" <joe@perches.com>,
        "=?utf-8?B?aG9ybXM=?=" <horms@verge.net.au>,
        "=?utf-8?B?ZGF2ZW0=?=" <davem@davemloft.net>
Cc: "=?utf-8?B?RnJhbmNvaXMgUm9taWV1?=" <romieu@fr.zoreil.com>,
        "=?utf-8?B?Z3JlZ2to?=" <gregkh@suse.de>,
        "=?utf-8?B?c3VuaGVjaGVuZw==?=" <sunhecheng@vip.126.com>,
        "=?utf-8?B?bGludXgtdXNi?=" <linux-usb@vger.kernel.org>,
        "=?utf-8?B?bmV0ZGV2?=" <netdev@vger.kernel.org>,
        "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
References: <201308201841116403992@163.com>,
 <20130820204606.GB26241@electric-eye.fr.zoreil.com>,
 <1377032302.2016.75.camel@joe-AO722>,
 <201308211807295009698@163.com>
Subject: =?utf-8?B?UmU6IFJlOiBSZTogW1BBVENILVNSOTcwMF0gTWVyZ2UgVVNCIDEuMSBFdGhlcm5ldCBBZGFwdGVyIFNSOTcwMERldmljZURyaXZlciBpbnRvIHRoZSBMaW51eCBLZXJuZWw=?=
Message-ID: <201308221723223905126@163.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
X-CM-TRANSID: EcCowEAZE0qJ2BVSzFslAQ--.199S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXFWUJr4DJr13uFyDJF1DZFb_yoW5Jw47pF
	WYgFyayF40gF1xZry8Zw1UWa4Fvw1rKasrCryDKasYvF98Ars5Ca40g34UXF15C3yfGF4r
	ZF4Y9r9xuF4UZ37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jrJ5rUUUUU=
X-CM-SenderInfo: xolxy3pqolt0hjboyzi6rwjhhfrp/1tbiqwuBX1EAE0Z-PAAAs5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7MAP84Z030029

Dear all :

		Thanks all of you about your attentions and suggestions, and I think firstly I should read the documentations carefully.

		and then commiting the patch. 

		Thanks all of you for your help and welcome all of you to come to china.

		Thanks again.



2013-08-22 



liujunliang_ljl 



å‘ä»¶äººï¼š Joe Perches 
å‘é€æ—¶é—´ï¼š 2013-08-21  19:34:10 
æ”¶ä»¶äººï¼š liujunliang_ljl 
æŠ„é€ï¼š Francois Romieu; gregkh; sunhecheng; linux-usb; netdev; linux-kernel 
ä¸»é¢˜ï¼š Re: Re: [PATCH-SR9700] Merge USB 1.1 Ethernet Adapter SR9700DeviceDriver into the Linux Kernel 
 
On Wed, 2013-08-21 at 18:07 +0800, liujunliang_ljl wrote:
>  Thanks a lot and I have been fixed all the problems mentioned above. please check the following patch and thanks again. 
Just trivial comments below:
> diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
[]
> +static void sr_write_reg_async(struct usbnet *dev, u8 reg, u8 value)
> +{
> + usbnet_write_cmd_async(dev, SR_WR_REGS, SR_REQ_WR_REG,
> + value, reg, NULL, 0);
> +}
> +
> +static int sr_share_read_word(struct usbnet *dev, int phy, u8 reg, __le16 *value)
> +{
[]
> + netdev_dbg(dev->net, "read shared %d 0x%02x returned 0x%04x, %d\n",
> +        phy, reg, *value, ret);
You have a lot of code that uses inconsistent
indentation.  Code in drivers/net and drivers/usb/net
generally prefers to use alignment to parenthesis for
multi-line statements
The first could use
usbnet_write_cmd_async(dev, SR_WR_REGS, SR_REQ_WR_REG,
       value, reg, NULL, 0);
and the second
netdev_dbg(dev->net, "read shared %d 0x%02x returned 0x%04x, %d\n",
   phy, reg, *value, ret);
Maximal use of 8 space indentation tabs followed by
minimal spaces.
There are many of these above.
> +static int sr9700_get_eeprom(struct net_device *net, struct ethtool_eeprom *eeprom, u8 *data)
[]
> + for (i = 0; i < eeprom->len / 2; i++)
> + ret = sr_read_eeprom_word(dev, eeprom->offset / 2 + i, &ebuf[i]);
One too many tabs for the second line, a few of these...
[]
> +static int sr_mdio_read(struct net_device *netdev, int phy_id, int loc)
[]
> + if (rc == 1)
> + return le16_to_cpu(res) | BMSR_LSTATUS;
> + else
> + return le16_to_cpu(res) & ~BMSR_LSTATUS;
The code below the returns here is unreachable.
> +
> + netdev_dbg(dev->net,
> +        "sr_mdio_read() phy_id=0x%02x, loc=0x%02x, returns=0x%04x\n",
> +        phy_id, loc, le16_to_cpu(res));
> +
> + return le16_to_cpu(res);
> +}
You might try to use scripts/checkpatch.pl --strict if you
care about these.  It should flag most of these coding
style inconsistencies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
