Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaLQBpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:45:43 -0500
Received: from mail-by2on0106.outbound.protection.outlook.com ([207.46.100.106]:29903
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750932AbaLQBpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:45:41 -0500
From: Dudley Du <dudl@cypress.com>
To: Benson Leung <bleung@google.com>, Jeremiah Mahler <jmmahler@gmail.com>,
        Dudley Du <dudley.dulixin@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v15 09/12] input: cyapa: add gen5 trackpad device firmware
 update function support
Thread-Topic: [PATCH v15 09/12] input: cyapa: add gen5 trackpad device
 firmware update function support
Thread-Index: AQHQGDAyhuu31c7xKUqOPbWVXmBXt5ySP9mAgABsZoCAAFVlsA==
Date: Wed, 17 Dec 2014 01:31:20 +0000
Message-ID: <BN1PR06MB070D98C13051B8FF6CB7778D16D0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1418624603-19054-1-git-send-email-dudley.dulixin@gmail.com>
	<1418624603-19054-10-git-send-email-dudley.dulixin@gmail.com>
	<20141216135639.GA1238@hudson.localdomain>
 <CANLzEks+hyNGy4_c+pHPW203oZUY=ms-cF3CttkW2NyRmNt8Zw@mail.gmail.com>
In-Reply-To: <CANLzEks+hyNGy4_c+pHPW203oZUY=ms-cF3CttkW2NyRmNt8Zw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
x-forefront-prvs: 042857DBB5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51164003)(51704005)(377454003)(199003)(189002)(13464003)(87936001)(107046002)(62966003)(107886001)(77156002)(99396003)(120916001)(19580395003)(50986999)(64706001)(2950100001)(20776003)(2900100001)(97736003)(93886004)(99286002)(46102003)(33656002)(15975445007)(102836002)(40100003)(2420400003)(31966008)(74316001)(106116001)(76576001)(76176999)(86362001)(54356999)(19580405001)(68736005)(101416001)(122556002)(4396001)(21056001)(106356001)(66066001)(92566001)(2656002)(105586002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB069;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBH1k3VK008753



> -----Original Message-----
> From: linux-input-owner@vger.kernel.org
> [mailto:linux-input-owner@vger.kernel.org] On Behalf Of Benson Leung
> Sent: 2014å¹´12æœˆ17æ—¥ 4:25
> To: Jeremiah Mahler; Dudley Du; Dmitry Torokhov; Henrik Rydberg; Benson Leung;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v15 09/12] input: cyapa: add gen5 trackpad device firmware
> update function support
>
> On Tue, Dec 16, 2014 at 5:56 AM, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> > On Mon, Dec 15, 2014 at 02:23:20PM +0800, Dudley Du wrote:
> >> Add firmware image update function supported for gen5 trackpad device,
> >> it can be used through sysfs update_fw interface.
> >> TEST=test on Chromebooks.
> >>
> >> Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
> >> ---
> >>  drivers/input/mouse/Kconfig      |   1 +
> >>  drivers/input/mouse/cyapa_gen5.c | 292
> ++++++++++++++++++++++++++++++++++++++-
> >>  2 files changed, 292 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> >> index d8b46b0..728490e 100644
> >> --- a/drivers/input/mouse/Kconfig
> >> +++ b/drivers/input/mouse/Kconfig
> >> @@ -206,6 +206,7 @@ config MOUSE_BCM5974
> >>  config MOUSE_CYAPA
> >>       tristate "Cypress APA I2C Trackpad support"
> >>       depends on I2C
> >> +     select CRC_ITU_T
> >>       help
> >
> > Just found out that if I2C_DESIGNWARE_PCI isn't enabled the touchpad
> > won't work.  Verify this on your machines.  Then perhaps add a depends
> > for I2C_DESIGNWARE_PCI instead of I2C since it would include the former.
>
> This isn't strictly true on all devices, though. This is true on
> DESIGNWARE_PCI based devices like the Acer C720 and the HP Chromebook
> 14, but on other platforms that use Cypress trackpads, such as ARM
> platforms like the Samsung Chromebook Series 3 DESIGNWARE_PCI is not
> required, and will just result in a driver that's never used being
> built.
>
> The specific I2C bus that's being used here shouldn't matter here...
> that's more of a platform issue. In the case with Chromebooks, it
> might make sense to change drivers/platform/chrome/Kconfig so that
> CHROMEOS_LAPTOP depends on I2C_DESIGNWARE_PCI, maybe.
>

Thank you all for the information.
Then I won't change this depending on I2C.

> --
> Benson Leung
> Software Engineer, Chrome OS
> Google Inc.
> bleung@google.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
