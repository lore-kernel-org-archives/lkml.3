Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaKJLFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:05:46 -0500
Received: from mail-bn1bon0138.outbound.protection.outlook.com ([157.56.111.138]:1913
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752703AbaKJLFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:05:41 -0500
X-Greylist: delayed 29848 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2014 06:05:41 EST
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dudley Du <dudley.dulixin@gmail.com>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v9 15/18] input: cyapa: add gen3 trackpad device read
 firmware image function support
Thread-Topic: [PATCH v9 15/18] input: cyapa: add gen3 trackpad device read
 firmware image function support
Thread-Index: AQHP90FZLjBMGvjiJUKHM+YLzb+D9pxZlUuAgAAirRA=
Date: Mon, 10 Nov 2014 11:05:39 +0000
Message-ID: <ad3bf85500174b25a4dc8f796d10d0a3@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
 <1415003590-30485-16-git-send-email-dudl@cypress.com>
 <20141110083955.GD39688@dtor-ws>
In-Reply-To: <20141110083955.GD39688@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB071;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB071;
x-forefront-prvs: 039178EF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(164054003)(199003)(51704005)(189002)(24454002)(51164003)(13464003)(99286002)(62966003)(77096003)(106356001)(77156002)(106116001)(21056001)(101416001)(105586002)(120916001)(97736003)(64706001)(92566001)(66066001)(86362001)(20776003)(99396003)(19580405001)(107046002)(19580395003)(108616004)(4396001)(87936001)(76576001)(40100003)(2656002)(31966008)(33646002)(74316001)(46102003)(95666004)(122556002)(50986999)(76176999)(54356999)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB071;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Dmitry

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2014?11?10? 16:40
> To: Dudley Du
> Cc: rydberg@euromail.se; Dudley Du; bleung@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v9 15/18] input: cyapa: add gen3 trackpad device read
> firmware image function support
>
> On Mon, Nov 03, 2014 at 04:33:07PM +0800, Dudley Du wrote:
> > Add read firmware image function supported for gen3 trackpad device,
> > it can be used through debugfs read_fw interface.
>
> Why do we need this? Can we do the same via usespace program accessing
> the i2c device through /dev/i2c-N?

This interface is used to test and debug only. It's defined and required by the chromium projects.

And in the driver side, becase the firmware image read process is done based on interrupt signal,
if do this in userspace through /dev/i2c-N, there will be two issues:
1) for gen5, after each command, an interrupt will be asserted, so if throug /dev/i2c-N,
userspace program cannot get the interrupt signal.
2) and when the interrupt signal assert, driver won't know it’s a command signal for image read,
so it will try to process it as data report.
To avoid this, additional interface must be added to mark the image read status and
block interrupt signal to be process as data report.

>
> Thanks.
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
