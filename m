Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbbASBwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:52:34 -0500
Received: from mail-bn1bon0115.outbound.protection.outlook.com ([157.56.111.115]:50432
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751736AbbASBwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:52:31 -0500
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "jmmahler@gmail.com" <jmmahler@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v18 12/12] input: cyapa: add acpi device id support
Thread-Topic: [PATCH v18 12/12] input: cyapa: add acpi device id support
Thread-Index: AQHQMVaa9Wtolj7IS02tcCo10syaCZzFjrkAgAEjMiA=
Date: Mon, 19 Jan 2015 01:52:27 +0000
Message-ID: <BN1PR06MB0701108C2E59BF84D70FC56D14A0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <1421390055-32760-13-git-send-email-dudl@cypress.com>
 <20150118082814.GD15720@dtor-ws>
In-Reply-To: <20150118082814.GD15720@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [140.207.206.26]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR06MB071;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB071;
x-forefront-prvs: 046164D5C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(51704005)(189002)(199003)(24454002)(51164003)(2900100001)(76576001)(54206007)(87936001)(110136001)(77156002)(62966003)(33656002)(64706001)(2656002)(2950100001)(46102003)(122556002)(40100003)(68736005)(66066001)(102836002)(99286002)(101416001)(86362001)(97736003)(74316001)(106116001)(54356999)(105586002)(76176999)(54606007)(92566002)(19580395003)(106356001)(19580405001)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB071;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2015 01:52:27.4425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR06MB071
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB197;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2015?1?18? 16:28
> To: Dudley Du
> Cc: jmmahler@gmail.com; rydberg@euromail.se; bleung@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v18 12/12] input: cyapa: add acpi device id support
>
> On Fri, Jan 16, 2015 at 02:34:15PM +0800, Dudley Du wrote:
> > Add acpi device tree support.
> > acpi device id "CYAP0000" is for old gen3 trackpad devices.
> > acpi device id "CYAP0001" is for new gen5 trackpad devices.
> > TEST=test on Chromebooks.
> >
> > Signed-off-by: Dudley Du <dudl@cypress.com>
> > ---
> >  drivers/input/mouse/cyapa.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> > index 5f9b24a..9dc9f65 100644
> > --- a/drivers/input/mouse/cyapa.c
> > +++ b/drivers/input/mouse/cyapa.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/slab.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/pm_runtime.h>
> > +#include <linux/acpi.h>
> >  #include "cyapa.h"
> >
> >
> > @@ -1356,11 +1357,23 @@ static const struct i2c_device_id cyapa_id_table[] = {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, cyapa_id_table);
> >
> > +#ifdef CONFIG_ACPI
> > +static const struct acpi_device_id cyapa_acpi_id[] = {
> > +{ "CYAP0000", 0 },  /* Gen3 trackpad with 0x67 I2C address. */
> > +{ "CYAP0001", 0 },  /* Gen5 trackpad with 0x24 I2C address. */
> > +{ }
> > +};
> > +MODULE_DEVICE_TABLE(acpi, cyapa_acpi_id);
> > +#endif
> > +
> >  static struct i2c_driver cyapa_driver = {
> >  .driver = {
> >  .name = "cyapa",
> >  .owner = THIS_MODULE,
> >  .pm = &cyapa_pm_ops,
> > +#ifdef CONFIG_ACPI
> > +.acpi_match_table = ACPI_PTR(cyapa_acpi_id),
>
> I do not think you should guard it with CONFIG_ACPI, so I dropped it.

Thanks.

>
> > +#endif
> >  },
> >
> >  .probe = cyapa_probe,
> > --
> > 1.9.1
> >
>
> Thanks.
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
