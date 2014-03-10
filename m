Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaCJMxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:53:06 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:51129
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753162AbaCJMxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:53:04 -0400
From: =?utf-8?B?U8O4cmVuc2VuLCBTdGVmYW4=?= 
	<Stefan.Sorensen@spectralink.com>
To: "richardcochran@gmail.com" <richardcochran@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhutchings@solarflare.com" <bhutchings@solarflare.com>,
        "christian.riesch@omicron.at" <christian.riesch@omicron.at>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v1 0/9] ptp: dynamic pin control
Thread-Topic: [PATCH RFC net-next v1 0/9] ptp: dynamic pin control
Thread-Index: AQHPOwaKm3RAZk4Gt02S4K3iXflNdZraSUEA
Date: Mon, 10 Mar 2014 12:52:57 +0000
Message-ID: <1394455974.2296.22.camel@e37108.spectralink.com>
References: <cover.1394307303.git.richardcochran@gmail.com>
In-Reply-To: <cover.1394307303.git.richardcochran@gmail.com>
Accept-Language: en-GB, de-DE, da-DK, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
x-originating-ip: [93.166.232.46]
x-forefront-prvs: 014617085B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(24454002)(189002)(199002)(95416001)(47446002)(97336001)(77156001)(77096001)(97186001)(74662001)(53806001)(76482001)(86362001)(76796001)(92726001)(76786001)(74876001)(74706001)(93136001)(92566001)(94946001)(56776001)(54316002)(33646001)(95666003)(69226001)(94316002)(93516002)(93916002)(87286001)(87266001)(74366001)(1411001)(74502001)(79102001)(62966002)(81542001)(4396001)(77982001)(59766001)(85306002)(50226001)(63696002)(47976001)(47736001)(50986001)(49866001)(81342001)(85202002)(2656002)(87936001)(85182001)(80976001)(83322001)(80022001)(65816001)(81816001)(51856001)(81686001)(66066001)(85852003)(83072002)(90146001)(89996001)(56816005)(88136002)(31966008)(46102001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR07MB510;H:DM2PR07MB334.namprd07.prod.outlook.com;CLIP:93.166.232.46;FPR:AC69523C.ACE25F5B.4DDD9D67.46E7E2B5.2022D;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1135BF2B223B9046AB209E53BDFCBE82@namprd07.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: spectralink.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2ACrGIJ016687

On Sat, 2014-03-08 at 20:42 +0100, Richard Cochran wrote:
> This patch series introduces a way of changing the auxiliary PTP
> Hardware Clock functions (periodic output signals and time stamping
> external signals) at run time. In the past on the netdev list, we have
> discussed other ways to handle this, such as module parameters and
> ethtool. This series implements a new PHC ioctl because that is the
> most natural way. Users already activate the auxiliary functions via
> the ioctls. The sysfs interface has also been expanded so that the pin
> configuration can be programmed using shell scripts.

A few general questions / thoughts:

What are the n_ext_ts and n_per_out supposed to be set to now? The
number of pins configured for the relevant function or the number of
channels that are available for the function?

The implementation is limited to a single function for each pin - the
dp83640 supports an ext_ts and several periodic outputs on the same pin,
but I do not see that many real-world uses. 

I have done a few short run-time tests, and so far everything is working
as expected.

Stefan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
