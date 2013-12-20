Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3LTPO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:14:29 -0500
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:54975
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3LTPO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:14:27 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jlee@suse.com" <jlee@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "Elliott@hp.com" <Elliott@hp.com>, "werner@suse.com" <werner@suse.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "trenn@suse.de" <trenn@suse.de>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "matt@console-pimps.org" <matt@console-pimps.org>
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI
 enabled
Thread-Topic: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI
 enabled
Thread-Index: AQHO/I+EcJVR10sMOECiIBe66SHBappbjsKAgADu+ICAAAGqAIAAZpKAgABNPoA=
Date: Fri, 20 Dec 2013 15:14:23 +0000
Message-ID: <1387552463.17961.2.camel@x230>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-7-git-send-email-jlee@suse.com>
	 <20131219140918.GF3145@console-pimps.org>
	 <1387513491.3539.4345.camel@linux-s257.site> <52B3C7F8.3040901@zytor.com>
	 <20131220103755.GA14784@pd.tnic>
In-Reply-To: <20131220103755.GA14784@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [176.35.175.187]
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51704005)(199002)(189002)(24454002)(377424004)(377454003)(479174003)(81816001)(80022001)(81686001)(77096001)(56776001)(66066001)(19580405001)(69226001)(83322001)(80976001)(74366001)(79102001)(2656002)(76796001)(76786001)(65816001)(63696002)(81542001)(81342001)(33716001)(59766001)(33646001)(77982001)(87936001)(87266001)(85306002)(54316002)(85852003)(19580395003)(53806001)(83072002)(76482001)(47976001)(50986001)(47736001)(54356001)(4396001)(74876001)(74706001)(49866001)(56816005)(90146001)(51856001)(46102001)(31966008)(47446002)(74662001)(74502001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB421;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:176.35.175.187;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <92B7898EFB5493428003ABBCD41DE64A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBKFEWsX013897

On Fri, 2013-12-20 at 11:37 +0100, Borislav Petkov wrote:
> On Thu, Dec 19, 2013 at 08:30:48PM -0800, H. Peter Anvin wrote:
> > On 12/19/2013 08:24 PM, joeyli wrote:
> > > I agreed, but userspace application should not be too often to access
> > > RTC. Maybe only when system boot and set timezone.
> >
> > This is, quite frankly, an idiotic argument.
> 
> TBH, I've been struggling with the question too - and it might even be a
> stupid question - but what is that absolute need to be able to get the
> TZ in userspace? Why should I care?
> 
> Can we get some use cases for stupid people like me please?

Dual-boot environments will tend to have the RTC in local time, not UTC.
That means that userspace has to reprogram the clock over daylight
savings changes, and to do that it must know whether another OS has
already done so.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
