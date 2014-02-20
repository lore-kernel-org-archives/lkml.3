Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaBTXJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:09:49 -0500
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:25671
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753770AbaBTXJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:09:48 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "rja@sgi.com" <rja@sgi.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq+l00AgAAHJxWAAAUvD4AACFkLgAAKotuAAArDa4AABr2A
Date: Thu, 20 Feb 2014 23:09:42 +0000
Message-ID: <1392937781.20109.24.camel@x230>
References: <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230>
	 <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>
	 <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230>
	 <20140220212854.GO17949@sgi.com> <1392932363.20109.11.camel@x230>
	 <20140220220656.GT17949@sgi.com> <1392935204.20109.17.camel@x230>
	 <20140220224529.GV17949@sgi.com>
In-Reply-To: <20140220224529.GV17949@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(199002)(189002)(377424004)(51704005)(83072002)(51856001)(81342001)(74706001)(19580395003)(80022001)(83322001)(94946001)(76796001)(76786001)(19580405001)(76482001)(74366001)(85852003)(81542001)(54356001)(95666003)(74876001)(56776001)(53806001)(90146001)(81686001)(46102001)(65816001)(74502001)(81816001)(94316002)(74662001)(56816005)(59766001)(4396001)(33716001)(87936001)(49866001)(47446002)(63696002)(80976001)(77096001)(93136001)(93516002)(92566001)(47736001)(69226001)(33646001)(95416001)(2656002)(54316002)(31966008)(77982001)(85306002)(86362001)(47976001)(87266001)(92726001)(50986001)(79102001)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:E0DCF5DF.AC16D721.71D0B992.4AE2D101.2035E;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9FBAACA72062D4C9A931BA5299C4AAE@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1KN9uWC022712

On Thu, 2014-02-20 at 16:45 -0600, Russ Anderson wrote:
> On Thu, Feb 20, 2014 at 10:26:45PM +0000, Matthew Garrett wrote:

> > Because I'm trying to ensure that the default behaviour of the kernel is
> > to *work*. Defaulting to having IPMI be modular means that the default
> > behaviour of the kernel, as far as the ACPI spec goes, is to be broken.
> 
> The ACPI spec requires IPMI functionality before a module loads at
> boot time?  And the kernel is *broken* if it does not support ACIP IPMI
> functionality before module load time?  Really?

There's no mechanism to ensure that IPMI support will be loaded before
ACPI calls attempt to access IPMI operation regions. Really.

> > ACPI 4.0 includes support for IPMI operation regions. Modular IPMI means
> > that the kernel will spend a significant amount of time (potentially
> > until a user manually loads a driver) failing to implement part of the
> > IPMI specification. That's a problem, and the correct fix is to ensure
> > that the kernel always implements IPMI support.
> 
> The ACPI spec says ipmi_si cannot be a driver?  Really?
> What is the real problem you are trying to solve?

The most straightforward case is that of an ACPI power meter. Several
vendors implement this with an IPMI operation region. Calling any of the
power meter functions will trigger access to that IPMI operation region,
which will fail. This may result in driver initialisation failing. There
is no express dependency between the power meter driver and ipmi_si,
because the spec envisages IPMI support as basic kernel functionality.
It's meant to be there before you start loading any other drivers.

> > Now, you've described some other problems. I don't disagree that those
> > are problems. The correct thing for us to do with those problems is to
> > fix them, not to simply change the kernel defaults such that it's
> > possible for users to choose between two differently broken states. I'm
> > absolutely willing to help, as long as you're willing to put some
> > reasonable amount of effort into describing them.
> 
> How about ACPI IPMI functionality starts when the ipmi_si
> module loads at boot time.  

I've repeatedly asked for you to provide detailed descriptions of the
problems you've seen because I have a genuine interest in fixing them.
If you're just going to childishly refuse then this discussion is
pointless. 

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
