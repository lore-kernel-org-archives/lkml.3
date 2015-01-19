Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbbASBwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:52:24 -0500
Received: from mail-bl2on0141.outbound.protection.outlook.com ([65.55.169.141]:51900
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179AbbASBwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:52:22 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2015 20:52:22 EST
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "jmmahler@gmail.com" <jmmahler@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v18 04/12] input: cyapa: add runtime power management
 interfaces support for the device
Thread-Topic: [PATCH v18 04/12] input: cyapa: add runtime power management
 interfaces support for the device
Thread-Index: AQHQMVaReX3P2OBoEEilMlozavTVkpzFj6SAgAEiqzA=
Date: Mon, 19 Jan 2015 01:52:20 +0000
Message-ID: <BN1PR06MB07098EF08CBC9493CC132CDD14A0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <1421390055-32760-5-git-send-email-dudl@cypress.com>
 <20150118083131.GE15720@dtor-ws>
In-Reply-To: <20150118083131.GE15720@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [140.207.206.26]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR06MB069;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
x-forefront-prvs: 046164D5C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51164003)(199003)(164054003)(51704005)(24454002)(13464003)(106116001)(19580405001)(19580395003)(54206007)(64706001)(66066001)(99286002)(106356001)(92566002)(54606007)(46102003)(86362001)(87936001)(33656002)(76576001)(74316001)(68736005)(50986999)(76176999)(101416001)(122556002)(2950100001)(54356999)(62966003)(105586002)(77156002)(2900100001)(110136001)(102836002)(97736003)(40100003)(2656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB069;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2015 01:52:20.4225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR06MB069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2015?1?18? 16:32
> To: Dudley Du
> Cc: jmmahler@gmail.com; rydberg@euromail.se; bleung@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v18 04/12] input: cyapa: add runtime power management
> interfaces support for the device
>
> Hi Dudley,
>
> On Fri, Jan 16, 2015 at 02:34:07PM +0800, Dudley Du wrote:
>
> > +#ifdef CONFIG_PM_RUNTIME
> > +static ssize_t cyapa_show_rt_suspend_scanrate(struct device *dev,
> > +      struct device_attribute *attr,
> > +      char *buf)
>
> The runtime PM was switched to just CONFIG_PM in mainline and
> CONFIG_PM_RUNTIME was dropped. I adjusted the patch accordingly.

Thanks, I will update my knowledge.;)

>
> ...
>
> > -static SIMPLE_DEV_PM_OPS(cyapa_pm_ops, cyapa_suspend, cyapa_resume);
> > +#ifdef CONFIG_PM_RUNTIME
> > +static int cyapa_runtime_suspend(struct device *dev)
>
> I switched both cyapa_runtme_suspend and resume to __maybe_unused and
> dropped #ifdef guards.
>
> Thanks.
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
