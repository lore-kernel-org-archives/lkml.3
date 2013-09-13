Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3IMU7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:59:20 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:20131
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907Ab3IMU7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:59:17 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h1155h)
From: "Getz, Robin" <Robin.Getz@analog.com>
To: Lee Jones <lee.jones@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>
CC: Jonathan Cameron <jic23@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: RE: [PATCH 27/38] iio: pressure-core: st: Give some indication if
 device probing was successful
Thread-Topic: [PATCH 27/38] iio: pressure-core: st: Give some indication if
 device probing was successful
Thread-Index: AQHOriUGKo/jKeEJhE6aM/vRwwNapZm/a4eAgAD3V4CAAAJDgIAAAw+AgAO/oHA=
Date: Fri, 13 Sep 2013 20:57:51 +0000
Message-ID: <FEAE1C531EE4684EBDD22603EC8BE59931CAB11B@NWD2MBX7.ad.analog.com>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-28-git-send-email-lee.jones@linaro.org>
 <43055af7-991f-4122-b308-a3dcddbbb72a@email.android.com>
 <20130911071053.GD11227@lee--X1> <52301963.5030006@metafoo.de>
 <20130911072955.GG11227@lee--X1>
In-Reply-To: <20130911072955.GG11227@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.113.65]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8DKxe2w025078

On Wednesday, September 11, 2013 3:30 AM Lee Jones wrote:
> On Wed, 11 Sep 2013, Lars-Peter Clausen wrote:
> > On 09/11/2013 09:10 AM, Lee Jones wrote:
> > >On Tue, 10 Sep 2013, Jonathan Cameron wrote:
> > >>Lee Jones <lee.jones@linaro.org> wrote:
> > Silence means everything is good, a message means there is an error.
> > If every device that gets probed would spit out a message the log
> > would be scrolling forever and you wouldn't be able to see the error
> > messages.
> 
> Only if you print out every regulator, clock, GPIO pin and things of this nature.
> Key hardware blocks such as; SD, Flash, USB, Eth, HDMI, Audio, UART, GPIO and
> I2C controllers and Sensors I think deserve a one line "I'm here and working"
> message.

In many embedded systems -- there are lots and lots of IIO devices, and I'm not sure 
I would consider very many "key". It really depends on the board.

To me it's a matter of boot time. Even memcpy to msgbuf takes time.
Sometimes unnecessary time.

> I'll not fight this for too long. This is based my experience as a user. I tried to
> look at the bootlog for the sensors I'd just enabled and there was nothing. Some
> of them had probed, some hadn't and there was no clear way to distinguish
> between them without digging into sysfs.

echo "working:"
cat /sys/bus/iio/devices/*/name

isn't too much digging. If you really want to do that on your machine - do so in rc.local

for many other subsystems, it's just not that easy, and printing from the driver is necessary.

-Robin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
