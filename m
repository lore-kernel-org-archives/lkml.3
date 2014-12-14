Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750841AbaLNSpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:45:24 -0500
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:50880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750702AbaLNSpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:45:22 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Michal Hocko <mhocko@suse.cz>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock issue in the
 memory hot-add code
Thread-Topic: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock issue in the
 memory hot-add code
Thread-Index: AQHQEOOmuVgs+XxEC0aWqcTs3cVwiZyFztOAgACs+YCAAIHigIAAFYwAgAAITACAAnA0MIAA1tCAgAUV2FA=
Date: Sun, 14 Dec 2014 18:45:17 +0000
Message-ID: <BY2PR0301MB07116E6E7D337FD68A7FD14DA06E0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417826471-21131-1-git-send-email-kys@microsoft.com>
 <1417826498-21172-1-git-send-email-kys@microsoft.com>
 <1417826498-21172-2-git-send-email-kys@microsoft.com>
 <20141208150445.GB29102@dhcp22.suse.cz> <54864F27.8010008@jp.fujitsu.com>
 <20141209090843.GA11373@dhcp22.suse.cz> <5486CE2E.4070409@jp.fujitsu.com>
 <20141209105532.GB11373@dhcp22.suse.cz>
 <BY2PR0301MB07118CFD9B32FEBE4E0C9921A0630@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20141211125829.GA19435@dhcp22.suse.cz>
In-Reply-To: <20141211125829.GA19435@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0709;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0709;
x-forefront-prvs: 0425A67DEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(479174003)(13464003)(51704005)(24454002)(189002)(377454003)(199003)(377424004)(102836002)(97736003)(99286002)(21056001)(15975445007)(62966003)(76576001)(19580405001)(106356001)(110136001)(64706001)(31966008)(93886004)(107046002)(2656002)(68736005)(46102003)(106116001)(20776003)(33656002)(74316001)(4396001)(101416001)(54206007)(122556002)(86612001)(66066001)(77156002)(105586002)(19580395003)(87936001)(99396003)(54356999)(50986999)(54606007)(92566001)(86362001)(76176999)(120916001)(40100003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0631;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2014 18:45:17.2853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0631
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michal Hocko [mailto:mhocko@suse.cz]
> Sent: Thursday, December 11, 2014 4:58 AM
> To: KY Srinivasan
> Cc: Yasuaki Ishimatsu; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; linux-mm@kvack.org
> Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock issue in the
> memory hot-add code
> 
> On Thu 11-12-14 00:21:09, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Michal Hocko [mailto:mhocko@suse.cz]
> > > Sent: Tuesday, December 9, 2014 2:56 AM
> > > To: Yasuaki Ishimatsu
> > > Cc: KY Srinivasan; gregkh@linuxfoundation.org; linux-
> > > kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > olaf@aepfle.de; apw@canonical.com; linux-mm@kvack.org
> > > Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock
> > > issue in the memory hot-add code
> > >
> > > On Tue 09-12-14 19:25:50, Yasuaki Ishimatsu wrote:
> > > > (2014/12/09 18:08), Michal Hocko wrote:
> > > [...]
> > > > >Doesn't udev retry the operation if it gets EBUSY or EAGAIN?
> > > >
> > > > It depend on implementation of udev.rules. So we can retry
> > > > online/offline operation in udev.rules.
> > > [...]
> > >
> > > # Memory hotadd request
> > > SUBSYSTEM=="memory", ACTION=="add",
> > > DEVPATH=="/devices/system/memory/memory*[0-9]",
> > > TEST=="/sys$devpath/state", RUN+="/bin/sh -c 'echo online >
> > > /sys$devpath/state'"
> > >
> > > OK so this is not prepared for a temporary failures and retries.
> > >
> > > > >And again, why cannot we simply make the onlining fail or
> > > > >try_lock and retry internally if the event consumer cannot cope with
> errors?
> > > >
> > > > Did you mean the following Srinivasan's first patch looks good to you?
> > > >   https://lkml.org/lkml/2014/12/2/662
> > >
> > > Heh, I was just about to post this. Because I haven't noticed the
> > > previous patch yet. Yeah, Something like that. Except that I would
> > > expect EAGAIN or EBUSY rather than ERESTARTSYS which should never
> > > leak into userspace. And that would happen here AFAICS because
> > > signal_pending will not be true usually.
> > Michal,
> >
> > I agree that the fix to this problem must be outside the clients of
> > add_memory() and that is the reason I had sent that patch:
> > https://lkml.org/lkml/2014/12/2/662. Let me know if you want me to
> > resend this patch with the correct return value.
> 
> Please think about the other suggested options as well.

Thanks Michal. I will look at the other options you have listed as well.

K. Y
> 
> > Regards,
> >
> > K. Y
> > >
> > > So there are two options. Either make the udev rule more robust and
> > > retry within RUN section or do the retry withing online_pages
> > > (try_lock and go into interruptible sleep which gets signaled by
> > > finished add_memory()). The later option is safer wrt. the userspace
> > > because the operation wouldn't fail unexpectedly.
> > > Another option would be generating the sysfs file after all the
> > > internal initialization is done and call it outside of the memory hotplug
> lock.
> > >
> > > --
> > > Michal Hocko
> > > SUSE Labs
> 
> --
> Michal Hocko
> SUSE Labs
