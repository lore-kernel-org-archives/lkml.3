Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbbASBfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:35:39 -0500
Received: from mail-bn1on0113.outbound.protection.outlook.com ([157.56.110.113]:43844
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751248AbbASBfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:35:37 -0500
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "jmmahler@gmail.com" <jmmahler@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v18 09/12] input: cyapa: add gen5 trackpad device firmware
 update function support
Thread-Topic: [PATCH v18 09/12] input: cyapa: add gen5 trackpad device
 firmware update function support
Thread-Index: AQHQMVaXd7veLXstjUCZz3Lce0JTkZzGmnsAgAAS+3A=
Date: Mon, 19 Jan 2015 01:35:33 +0000
Message-ID: <BN1PR06MB070FC8E3B476865011A00EED14A0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <1421390055-32760-10-git-send-email-dudl@cypress.com>
 <20150119002634.GA23278@dtor-glaptop>
In-Reply-To: <20150119002634.GA23278@dtor-glaptop>
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
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(51914003)(51164003)(199003)(51704005)(13464003)(74316001)(97736003)(54356999)(106116001)(86362001)(19580405001)(50986999)(106356001)(105586002)(54606007)(76176999)(92566002)(19580395003)(64706001)(2656002)(77156002)(62966003)(110136001)(76576001)(2900100001)(87936001)(54206007)(33656002)(68736005)(101416001)(99286002)(66066001)(102836002)(122556002)(40100003)(46102003)(2950100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB071;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2015 01:35:33.1526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR06MB071
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB389;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2015?1?19? 8:27
> To: Dudley Du
> Cc: jmmahler@gmail.com; rydberg@euromail.se; bleung@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v18 09/12] input: cyapa: add gen5 trackpad device firmware
> update function support
>
> On Fri, Jan 16, 2015 at 02:34:12PM +0800, Dudley Du wrote:
> > +/* APP_INTEGRITY row is always the last row block,
> > + * and the row id must be 0x01ff */
> > +row_num = get_unaligned_be16(
> > +&image->records[flash_records_count - 1].row_number);
> > +if (image->records[flash_records_count - 1].flash_array_id != 0x00 &&
> > +row_num != 0x01ff) {
>
> By the way, shouldn't this be "or" and not "and"?

It should or, thanks for the correction.

>
> > +dev_err(dev, "%s: invalid app_integrity data.\n", __func__);
> > +return -EINVAL;
> > +}
>
> Thanks.
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
