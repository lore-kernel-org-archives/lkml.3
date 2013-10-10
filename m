Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3JJNnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:43:33 -0400
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:20054
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611Ab3JJNnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:43:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Bhushan Bharat-R65777 <R65777@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>
CC: Kim Phillips <kim.phillips@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: RFC: (re-)binding the VFIO platform driver to a platform device
Thread-Topic: RFC: (re-)binding the VFIO platform driver to a platform device
Thread-Index: AQHOvtVyiXjaos/F7ECAilSa5Xx4A5ngRDQAgAAiCgCAAECXgIAAC74AgADT3ICAADSaMIAAAtYAgAADCQCAAB/ggIAACLGAgAACMICAAAU8gIAAIuWAgAE8pICAAAXnAIAABMAAgAAWmACACVE7IIAACQSAgAAB3+CAAAm8gIAAxBKAgABjQBA=
Date: Thu, 10 Oct 2013 13:43:22 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E15036DF30E@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1380738758.12932.43.camel@snotra.buserror.net>
	 <20131002184330.GC5108@cbox> <20131002203735.GA10871@kroah.com>
	 <1380748121.12932.89.camel@snotra.buserror.net>
	 <20131002211631.GA11914@kroah.com>
	 <1380749715.12932.109.camel@snotra.buserror.net>
	 <20131002234009.GA27714@kroah.com>
	 <1380825207.12932.151.camel@snotra.buserror.net>
	 <20131003185434.GA26123@kroah.com>
	 <1380827494.12932.161.camel@snotra.buserror.net>
	 <20131003203226.GB27336@kroah.com>
	 <9F6FE96B71CF29479FF1CDC8046E15036DDA62@039-SN1MPN1-002.039d.mgd.msft.net>
	 <1381346507.7979.334.camel@snotra.buserror.net>
	 <9F6FE96B71CF29479FF1CDC8046E15036DDAB4@039-SN1MPN1-002.039d.mgd.msft.net>
 <1381348999.7979.360.camel@snotra.buserror.net>
 <6A3DF150A5B70D4F9B66A25E3F7C888D071AEE4C@039-SN2MPN1-012.039d.mgd.msft.net>
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D071AEE4C@039-SN2MPN1-012.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.86.89]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9ADheRM020743

> I am trying to understand what you are proposing here (example "DEVICE"
> can be handled by "DRIVER1" and "VFIO-PLATFORM-DRIVER"):
>  - By default drv->explicit_bind_only will be clear in all drivers.
>  - By default device->explicit_bind_only will also be clear for all
> devices.
>  - On boot, matching devices will bound to the respective driver (DEVICE
> >==> DRIVER1).
>    This will never bound with VFIO-PLATFORM-DRIVER. So far same as
> before.
>  - Via Sysfs interface set drv->explicit_bind_only for VFIO-PLATFORM-
> DRIVER.

No.  VFIO-PLATFORM-DRIVER is _always_ explicit_bind_only and thus will be
statically set in the driver.  See Kim's patch.

>  - Then for the devices user want, set device->explicit_bind_only.
>  - unbind DEVICE from DRIVER1
>  - bind DEVICE with VFIO-PLATFORM-DRIVER. This time it will be successful
> because (device->explicit_bind_only && drv->explicit_bind_only) is set.
>  - Now when done, unbind the DEVICE from VFIO-PLATFORM-DRIVER.
>  - Now user can re-bind the device with either DRIVER1 or VFIO-PLATFORM-
> DRIVER.
>  - Now once drv->explicit_bind_only is set in VFIO-PLATFORM-DRIVER, and a
> new device comes (device - hotplug) then can gets bound to matching drive
> and not with VFIO-PLATFORM-DRIVER.

Otherwise, it looks correct to me.

Stuart
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
