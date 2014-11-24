Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750991AbaKXVzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:55:06 -0500
Received: from mail-by2on0115.outbound.protection.outlook.com ([207.46.100.115]:1740
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750755AbaKXVzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:55:05 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] hv: hv_balloon: avoid memory leak on alloc_error of 2MB
 memory block
Thread-Topic: [PATCH] hv: hv_balloon: avoid memory leak on alloc_error of 2MB
 memory block
Thread-Index: AQHQB6G3E+bQySwNgEW07j62p0+FxJxvPNOAgAAN8ACAABZaAIAAB1kAgAAO14CAAAI2AIAA2GcA
Date: Mon, 24 Nov 2014 21:55:01 +0000
Message-ID: <BY2PR0301MB0711E18522F3128D46097D11A0720@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1416808575-5383-1-git-send-email-decui@microsoft.com>
 <5472BF95.2000904@redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E5FD2B@HKNPRD3002MB017.064d.mgd.msft.net>
 <5472DE06.6000307@redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E5FE48@HKNPRD3002MB017.064d.mgd.msft.net>
 <5472F0A3.1010702@redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E5FFC0@HKNPRD3002MB017.064d.mgd.msft.net>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E5FFC0@HKNPRD3002MB017.064d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-forefront-prvs: 040513D301
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(6009001)(52604005)(199003)(51704005)(164054003)(479174003)(13464003)(377454003)(189002)(24454002)(101416001)(2201001)(50986999)(107046002)(93886004)(76576001)(86362001)(54206007)(2421001)(2501002)(92726001)(46102003)(19580405001)(21056001)(92566001)(74316001)(2561002)(105586002)(99396003)(120916001)(106116001)(40100003)(95666004)(64706001)(77156002)(62966003)(77096003)(106356001)(31966008)(20776003)(87936001)(99286002)(54356999)(1511001)(33656002)(86612001)(4396001)(97736003)(2656002)(19580395003)(122556002)(54606007)(76176999)(3826002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui
> Sent: Monday, November 24, 2014 12:55 AM
> To: Jason Wang; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> driverdev-devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; KY Srinivasan
> Cc: Haiyang Zhang
> Subject: RE: [PATCH] hv: hv_balloon: avoid memory leak on alloc_error of
> 2MB memory block
> 
> > -----Original Message-----
> > From: Jason Wang [mailto:jasowang@redhat.com]
> > Sent: Monday, November 24, 2014 16:48 PM
> > To: Dexuan Cui; gregkh@linuxfoundation.org;
> > linux-kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org;
> > olaf@aepfle.de; apw@canonical.com; KY Srinivasan
> > Cc: Haiyang Zhang
> > Subject: Re: [PATCH] hv: hv_balloon: avoid memory leak on alloc_error
> > of 2MB memory block
> >
> > On 11/24/2014 03:54 PM, Dexuan Cui wrote:
> > >> -----Original Message-----
> > >> From: Jason Wang [mailto:jasowang@redhat.com]
> > >> Sent: Monday, November 24, 2014 15:28 PM
> > >> To: Dexuan Cui; gregkh@linuxfoundation.org; linux-
> > kernel@vger.kernel.org;
> > >> driverdev-devel@linuxdriverproject.org; olaf@aepfle.de;
> > >> apw@canonical.com; KY Srinivasan
> > >> Cc: Haiyang Zhang
> > >> Subject: Re: [PATCH] hv: hv_balloon: avoid memory leak on
> > >> alloc_error
> > of
> > >> 2MB memory block
> > >>
> > >> On 11/24/2014 02:08 PM, Dexuan Cui wrote:
> > >>>> -----Original Message-----
> > >>>>> From: Jason Wang [mailto:jasowang@redhat.com]
> > >>>>> Sent: Monday, November 24, 2014 13:18 PM
> > >>>>> To: Dexuan Cui; gregkh@linuxfoundation.org; linux-
> > >> kernel@vger.kernel.org;
> > >>>>> driverdev-devel@linuxdriverproject.org; olaf@aepfle.de;
> > >>>>> apw@canonical.com; KY Srinivasan
> > >>>>> Cc: Haiyang Zhang
> > >>>>> Subject: Re: [PATCH] hv: hv_balloon: avoid memory leak on
> > >> alloc_error of
> > >>>>> 2MB memory block
> > >>>>>
> > >>>>> On 11/24/2014 01:56 PM, Dexuan Cui wrote:
> > >>>>>>> If num_ballooned is not 0, we shouldn't neglect the already-
> > >> allocated
> > >>>>> 2MB
> > >>>>>>> memory block(s).
> > >>>>>>>
> > >>>>>>> Cc: K. Y. Srinivasan <kys@microsoft.com>
> > >>>>>>> Cc: <stable@vger.kernel.org>
> > >>>>>>> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > >>>>>>> ---
> > >>>>>>>  drivers/hv/hv_balloon.c | 4 +++-
> > >>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> > >>>>>>>
> > >>>>>>> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> > >>>>>>> index 5e90c5d..cba2d3b 100644
> > >>>>>>> --- a/drivers/hv/hv_balloon.c
> > >>>>>>> +++ b/drivers/hv/hv_balloon.c
> > >>>>>>> @@ -1091,6 +1091,8 @@ static void balloon_up(struct
> > >> work_struct
> > >>>>> *dummy)
> > >>>>>>>  	bool done = false;
> > >>>>>>>  	int i;
> > >>>>>>>
> > >>>>>>> +	/* The host does balloon_up in 2MB. */
> > >>>>>>> +	WARN_ON(num_pages % PAGES_IN_2M != 0);
> > >>>>>>>
> > >>>>>>>  	/*
> > >>>>>>>  	 * We will attempt 2M allocations. However, if we fail to @@
> > >>>>>>> -1111,7 +1113,7 @@ static void balloon_up(struct
> > >> work_struct
> > >>>>> *dummy)
> > >>>>>>>  						bl_resp, alloc_unit,
> > >>>>>>>  						 &alloc_error);
> > >>>>>>>
> > >>>>>>> -		if ((alloc_error) && (alloc_unit != 1)) {
> > >>>>>>> +		if (alloc_error && (alloc_unit != 1) &&
> > >> num_ballooned == 0)
> > >>>>> {
> > >>>>>>>  			alloc_unit = 1;
> > >>>>>>>  			continue;
> > >>>>>>>  		}
> > >>>>> Before the change, we may retry the 4K allocation when part or
> > >>>>> all
> > 2M
> > >>>>> allocations were failed. This makes sense when memory is
> > fragmented.
> > >> But
> > >>> Yes, but all the partially-allocated 2MB memory blocks are
> > >>> lost(mem
> > leak).
> > >>>
> > >>>>> after the change, if part of 2M allocation were failed, we won't
> > >>>>> retry 4K allocation. Is this expected?
> > >>> Hi Jason,
> > >>> The patch doesn't break the "try 2MB first; then try 4K" logic:
> > >>>
> > >>> With the change, we'll retry the 2MB allocation in the next
> > >>> iteration of
> > the
> > >>> same while (!done) loop -- we expect this retry will cause
> > >>> "alloc_error && (alloc_unit != 1) && num_ballooned == 0" to be
> > >>> true, so we'll later try 4K allocation, as we did before.
> > >> If I read the code correctly, if part of 2M allocation fails.
> > >> alloc_balloon_pages() will have a non zero return value with
> > >> alloc_error set. Then it will match the following check:
> > >>
> > >>                 if ((alloc_error) || (num_ballooned == num_pages))
> > >> {
> > >>
> > >> which will set done to true. So there's no second iteration of
> > >> while
> > >> (!done) loop?
> > > Oh... I see the issue in my patch.
> > > Thanks for pointing this out, Jason!
> > >
> > >> Probably you need something like:
> > >>
> > >> if ((alloc_unit != 1) && (num_ballooned == 0)) {
> > >>     alloc_unit = 1;
> > >>     continue;
> > >> }
> > >>
> > >> if ((alloc_unit == 1) || (num_ballooned == num_pages)) {
> > >>     ...
> > >> }
> > > Your code is good, except for one thing:
> > > alloc_balloon_pages() can return due to:
> > >
> > > if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
> > >                          PAGE_SIZE)
> > >                         return i * alloc_unit;
> > >
> > > In this case, "alloc_unit == 1" is true, but we shouldn't run "done = true".
> > >
> > > How do you like this? I made a few changes based on your code.
> > >
> > > @@ -1086,16 +1088,18 @@ static void balloon_up(struct work_struct
> > *dummy)
> > >                 num_pages -= num_ballooned;
> > > +               alloc_error = false;
> > >                 num_ballooned = alloc_balloon_pages(&dm_device,
> num_pages,
> > >                                                 bl_resp, alloc_unit,
> > >                                                  &alloc_error);
> > >
> > > -               if ((alloc_error) && (alloc_unit != 1)) {
> > > +               if (alloc_unit != 1 && num_ballooned == 0) {
> > >                         alloc_unit = 1;
> > >                         continue;
> > >                 }
> > >
> > > -               if ((alloc_error) || (num_ballooned == num_pages)) {
> > > +               if ((alloc_unit == 1 && alloc_error) ||
> > > +                       (num_ballooned == num_pages)) {
> > >                         bl_resp->more_pages = 0;
> > >                         done = true;
> > >                         dm_device.state = DM_INITIALIZED;
> > >
> > >
> > > If you're Ok with this, I'll send out a v2 patch.
> > > -- Dexuan
> >
> > Looks good.
> Thanks, Jason!
> 
> Let's wait for KY's clarification about if the host can balloon up 1MB.

The patch looks good. Yes, the host balloons pages in 2M granularity. This is the behavior of the
current Windows hosts supporting this feature.

Regards,

K. Y
> 
> I'll send the v2 thereafter.
> 
> -- Dexuan
> 

