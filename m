Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468AbaLEBnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:43:24 -0500
Received: from mail-by2on0145.outbound.protection.outlook.com ([207.46.100.145]:40449
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932975AbaLEBnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:43:22 -0500
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Solda <dso@cypress.com>
Subject: RE: [PATCH v9 15/18] input: cyapa: add gen3 trackpad device read
 firmware image function support
Thread-Topic: [PATCH v9 15/18] input: cyapa: add gen3 trackpad device read
 firmware image function support
Thread-Index: AQHP90FZLjBMGvjiJUKHM+YLzb+D9pxZlUuAgAAirRCAJi4KgIAAghyA
Date: Fri, 5 Dec 2014 01:43:18 +0000
Message-ID: <BN1PR06MB070398D7C243AB4221A8AC8D1790@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
 <1415003590-30485-16-git-send-email-dudl@cypress.com>
 <20141110083955.GD39688@dtor-ws>
 <ad3bf85500174b25a4dc8f796d10d0a3@BN1PR06MB070.namprd06.prod.outlook.com>
 <20141204174641.GB4806@dtor-ws>
In-Reply-To: <20141204174641.GB4806@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0601MB1074;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0601MB1074;
x-forefront-prvs: 04163EF38A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(57704003)(199003)(164054003)(51704005)(13464003)(51164003)(24454002)(19580395003)(31966008)(101416001)(19580405001)(76176999)(54206007)(33656002)(68736005)(54356999)(86362001)(54606007)(50986999)(2656002)(92566001)(102836002)(66066001)(20776003)(99396003)(64706001)(87936001)(120916001)(62966003)(77156002)(110136001)(93886004)(105586002)(106116001)(106356001)(99286002)(122556002)(107046002)(97736003)(21056001)(4396001)(74316001)(76576001)(46102003)(40100003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0601MB1074;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0601MB1316;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB51hV7q006662



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2014å¹´12æœˆ5æ—¥ 1:47
> To: Dudley Du
> Cc: Dudley Du; rydberg@euromail.se; bleung@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v9 15/18] input: cyapa: add gen3 trackpad device read
> firmware image function support
>
> On Mon, Nov 10, 2014 at 11:05:39AM +0000, Dudley Du wrote:
> > Thanks, Dmitry
> >
> > > -----Original Message-----
> > > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > > Sent: 2014?11?10? 16:40
> > > To: Dudley Du
> > > Cc: rydberg@euromail.se; Dudley Du; bleung@google.com;
> > > linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH v9 15/18] input: cyapa: add gen3 trackpad device read
> > > firmware image function support
> > >
> > > On Mon, Nov 03, 2014 at 04:33:07PM +0800, Dudley Du wrote:
> > > > Add read firmware image function supported for gen3 trackpad device,
> > > > it can be used through debugfs read_fw interface.
> > >
> > > Why do we need this? Can we do the same via usespace program accessing
> > > the i2c device through /dev/i2c-N?
> >
> > This interface is used to test and debug only. It's defined and required by the
> chromium projects.
> >
> > And in the driver side, becase the firmware image read process is done based on
> interrupt signal,
> > if do this in userspace through /dev/i2c-N, there will be two issues:
> > 1) for gen5, after each command, an interrupt will be asserted, so if throug
> /dev/i2c-N,
> > userspace program cannot get the interrupt signal.
> > 2) and when the interrupt signal assert, driver won't know itâ€™s a command signal
> for image read,
> > so it will try to process it as data report.
> > To avoid this, additional interface must be added to mark the image read status
> and
> > block interrupt signal to be process as data report.
>
> I believe that while userspace acc4esses the device through /dev/i2c-N
> you should unbind the cyapa driver from the device (via sysfs driver
> core bind/unbind attribute) so that it doe snot get in the way. Once
> diagnostics is done you can bind the driver back to device, restoring
> normal operation.
>
> That is how we are planning to handle other devices at factory as
> well.

Thanks, I will remove the debugfs interfaces from the patach series.

>
> Thanks.
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
