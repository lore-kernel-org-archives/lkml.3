Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaIWKDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:03:38 -0400
Received: from mail-bn1bon0115.outbound.protection.outlook.com ([157.56.111.115]:23264
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754283AbaIWKDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:03:36 -0400
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 06:03:36 EDT
From: Thomas Shao <huishao@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Drivers: hv: util: Implement Time Synchronization using
 host time sample
Thread-Topic: [PATCH] Drivers: hv: util: Implement Time Synchronization
 using host time sample
Thread-Index: AQHP1vKMtDPVAvlpRESa+FlYjIeumZwOWccAgAAXQzA=
Date: Tue, 23 Sep 2014 09:47:59 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD8401415408E2A9@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1411451081-13423-1-git-send-email-huishao@microsoft.com>
 <20140923075610.GA10933@aepfle.de>
In-Reply-To: <20140923075610.GA10933@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(189002)(13464003)(377454003)(199003)(24454002)(51704005)(64706001)(84676001)(77096002)(50986999)(85852003)(90102001)(4396001)(95666004)(76176999)(86362001)(20776003)(21056001)(47776003)(66066001)(99396002)(86612001)(54356999)(33656002)(87936001)(50466002)(86146001)(81156004)(106466001)(2656002)(81342003)(74502003)(46102003)(6806004)(77982003)(76482002)(80022003)(107046002)(79102003)(81542003)(74662003)(19580395003)(68736004)(55846006)(69596002)(83322001)(19580405001)(44976005)(110136001)(31966008)(83072002)(106116001)(92566001)(92726001)(23676002)(85306004)(120916001)(16796002)(10300001)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1209;H:mail.microsoft.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1209;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0343AC1D30
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8NA3hnx003177


> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, September 23, 2014 3:56 PM
> To: Thomas Shao
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> driverdev-devel@linuxdriverproject.org; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: [PATCH] Drivers: hv: util: Implement Time Synchronization using
> host time sample
> 
> On Tue, Sep 23, Thomas Shao wrote:
> 
> > In current hyper-v time sync service,it only gets the initial clock
> > time from the host. It didn't process the following time samples. This
> > change introduced a module parameter called host_time_sync. If it is
> > set to true, the guest will periodically sychronize it's time with the
> > host clock using host time sample. By default it is disabled, because
> > we still recommend user to configure NTP for time synchronization.
> 
> Is that new knob a temporary thing to aid testing and development?
> Because once it sneaks in it becomes some sort of ABIT.
> So if the outcome of all that is that 'sync with host every once in a while' will be
> the default, the new knob is not required.
> 

Hi Olaf, 
If the guest is configured with other time sync source, like NTP, we don't want the 
guest to periodically sync with host. This feature is useful when the guest didn't have
Internet connection to setup NTP. So the new knob is to allow users to only turn on the
host-guest sync when they need.

Regards
Thomas

> Olaf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
