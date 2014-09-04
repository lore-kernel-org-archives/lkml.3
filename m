Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbaIDCDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 22:03:18 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:2401
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751118AbaIDCDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 22:03:16 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5] Clocksource: Flextimer: Fix counter clock prescaler
 calculation.
Thread-Topic: [PATCH 4/5] Clocksource: Flextimer: Fix counter clock prescaler
 calculation.
Thread-Index: AQHPwPGhd5+7l5+n2ECz3VCyJKPGDJvvSnoAgAD6NsA=
Date: Thu, 4 Sep 2014 02:03:14 +0000
Message-ID: <c69ed0ca405b477685ed046894bc1c6e@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
 <1409031951-39021-5-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.10.1409031257520.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409031257520.3333@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(24454002)(199003)(189002)(101416001)(76482001)(77096002)(80022001)(74662001)(20776003)(105586002)(87936001)(79102001)(74502001)(85852003)(110136001)(21056001)(76176999)(92566001)(66066001)(64706001)(46102001)(83072002)(107046002)(76576001)(108616004)(90102001)(95666004)(2656002)(85306004)(106356001)(54356999)(81542001)(4396001)(99396002)(50986999)(31966008)(77982001)(99286002)(106116001)(83322001)(81342001)(74316001)(86362001)(33646002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks very much for your comments.

Firstly I must tell the true that English is not my mother language.


> Subject: Re: [PATCH 4/5] Clocksource: Flextimer: Fix counter clock prescaler
> calculation.
> 
> On Tue, 26 Aug 2014, Xiubo Li wrote:
> 
> > We should minus one after calculating the counter input clock's
> > prescaler.
> 
> And that's a complete useless changelog.
> 
> A) It lacks a proper description of the problem
> 
> B) It lacks a proper argument WHY we must decrement the prescaler
>    value
> 
>    Hint: I used the verb "must" instead of "should". Can you figure
>    out why?
> 

Yes, we should use 'must' here, because we are using 'ps++' in the loop code,
the correct value should be 'ps = ps - 1', after the loop.

BRs
Xiubo
