Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaIZJrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:47:22 -0400
Received: from mail-by2on0141.outbound.protection.outlook.com ([207.46.100.141]:41906
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754170AbaIZJrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:47:19 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Mike Surcouf <mps.surcouf.lkml@gmail.com>
CC: Sitsofe Wheeler <sitsofe@gmail.com>, Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: Time keeps on slipping... on Hyper-V
Thread-Topic: Time keeps on slipping... on Hyper-V
Thread-Index: AQHP2MSs3f6Dn2FF4EqEMJgPvPUmjJwS92OggAAuT4CAAAVtwA==
Date: Fri, 26 Sep 2014 09:46:27 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD84014154097C10@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1411451081-13423-1-git-send-email-huishao@microsoft.com>
	<20140923075610.GA10933@aepfle.de>	<20140925060745.GA9450@sucs.org>
	<CD2CABCB2C0A0D4682C5F8AD84014154094643@HKXPRD3002MB006.064d.mgd.msft.net>
	<20140925132055.GA13108@sucs.org>
	<CD2CABCB2C0A0D4682C5F8AD8401415409741D@HKXPRD3002MB006.064d.mgd.msft.net>
 <CAL7Bo8EP8he+OycqAnnNOD+W9eZ=qYfUNXFJ5zffUHq_0GUxYQ@mail.gmail.com>
In-Reply-To: <CAL7Bo8EP8he+OycqAnnNOD+W9eZ=qYfUNXFJ5zffUHq_0GUxYQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(13464003)(51704005)(51714002)(189002)(199003)(377454003)(90102001)(69596002)(68736004)(83072002)(44976005)(20776003)(47776003)(83322001)(10300001)(120916001)(19580395003)(19580405001)(86362001)(23676002)(92566001)(21056001)(99396003)(85852003)(6806004)(54356999)(106116001)(50986999)(55846006)(4396001)(64706001)(76176999)(84676001)(95666004)(106466001)(81156004)(86146001)(92726001)(87936001)(2656002)(110136001)(93886004)(85306004)(79102003)(77096002)(77982003)(66066001)(46102003)(50466002)(74662003)(80022003)(74502003)(81342003)(81542003)(76482002)(107046002)(33656002)(31966008)(97736003)(16796002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1210;H:mail.microsoft.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1210;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8Q9lQOu029569



> -----Original Message-----
> From: Mike Surcouf [mailto:mps.surcouf.lkml@gmail.com]
> Sent: Friday, September 26, 2014 5:24 PM
> To: Thomas Shao
> Cc: Sitsofe Wheeler; Olaf Hering; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: Time keeps on slipping... on Hyper-V
> 
> > We still recommend user to configure NTP in the guest VM. With the new
> > time sync feature in this patch, you could have one more option to enable
> the guest-host sync, if the NTP didn't work in the environment.
> > For example the guest VM didn't have network connection.
> 
> Microsoft used to use host time-samples in their older drivers but this was
> dropped (when I don't know).
> Now we must use NTP to correct hyperv_clocksource which suffers from the
> usual problems associated with virtual environment  cpu loading.
> 
> Host time-samples in conjunction with an effective clock stability algorithm
> with slews rather than steps should be the default.
> NTP is a workaround and should not be the primary solution.
> 
> I have seen a lots of posts for RHEL CENTOS  Linux that have a
> FAST.hyper_clocksource confirmed by myself on CENTOS 6.5 and 7.0 (also
> confirmed by Olaf on SLES).
> 
> If this patch steps the clock once in a while without any form of slewing then
> it has the potential to break things as files and logs travel BACK in time.
> 
> Apologies Thomas could you send me the patch via email as lkml.org does
> not have it in the archives.
> 
Sure. I'll send the package again. It's strange that this patch didn't in the archives. And in my patch, it will slew the time, if the time drift is less than 1 s. It only steps the clock if the drift is larger than 1 s.

> Regards Mike
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
