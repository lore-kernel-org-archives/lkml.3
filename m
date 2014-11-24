Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaKXHzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:55:06 -0500
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:40632
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752532AbaKXHzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 02:55:04 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Jason Wang <jasowang@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        KY Srinivasan <kys@microsoft.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] hv: hv_balloon: avoid memory leak on alloc_error of 2MB
 memory block
Thread-Topic: [PATCH] hv: hv_balloon: avoid memory leak on alloc_error of
 2MB memory block
Thread-Index: AQHQB6k84XUNZum87EGSQXE5iVJZTZxvRrkAgAAaVQCAAANSUA==
Date: Mon, 24 Nov 2014 07:54:24 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E5FE48@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1416808575-5383-1-git-send-email-decui@microsoft.com>
 <5472BF95.2000904@redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E5FD2B@HKNPRD3002MB017.064d.mgd.msft.net>
 <5472DE06.6000307@redhat.com>
In-Reply-To: <5472DE06.6000307@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(479174003)(164054003)(377454003)(189002)(24454002)(199003)(52604005)(51704005)(13464003)(50986999)(76176999)(54356999)(97736003)(2561002)(84676001)(19580405001)(19580395003)(4396001)(120916001)(44976005)(68736004)(69596002)(6806004)(99396003)(97756001)(93886004)(2656002)(87936001)(2501002)(86146001)(55846006)(21056001)(95666004)(86362001)(107046002)(86612001)(50466002)(106116001)(23726002)(81156004)(106466001)(26826002)(1511001)(33656002)(2201001)(92726001)(92566001)(2421001)(46102003)(46406003)(16796002)(31966008)(77096003)(77156002)(62966003)(47776003)(20776003)(64706001)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1205;H:mail.microsoft.com;FPR:;SPF:Pass;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1205;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1205;
X-Forefront-PRVS: 040513D301
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1205;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Monday, November 24, 2014 15:28 PM
> To: Dexuan Cui; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> driverdev-devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; KY Srinivasan
> Cc: Haiyang Zhang
> Subject: Re: [PATCH] hv: hv_balloon: avoid memory leak on alloc_error of
> 2MB memory block
> 
> On 11/24/2014 02:08 PM, Dexuan Cui wrote:
> >> -----Original Message-----
> >> > From: Jason Wang [mailto:jasowang@redhat.com]
> >> > Sent: Monday, November 24, 2014 13:18 PM
> >> > To: Dexuan Cui; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org;
> >> > driverdev-devel@linuxdriverproject.org; olaf@aepfle.de;
> >> > apw@canonical.com; KY Srinivasan
> >> > Cc: Haiyang Zhang
> >> > Subject: Re: [PATCH] hv: hv_balloon: avoid memory leak on
> alloc_error of
> >> > 2MB memory block
> >> >
> >> > On 11/24/2014 01:56 PM, Dexuan Cui wrote:
> >>> > > If num_ballooned is not 0, we shouldn't neglect the already-
> allocated
> >> > 2MB
> >>> > > memory block(s).
> >>> > >
> >>> > > Cc: K. Y. Srinivasan <kys@microsoft.com>
> >>> > > Cc: <stable@vger.kernel.org>
> >>> > > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> >>> > > ---
> >>> > >  drivers/hv/hv_balloon.c | 4 +++-
> >>> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> >>> > >
> >>> > > diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> >>> > > index 5e90c5d..cba2d3b 100644
> >>> > > --- a/drivers/hv/hv_balloon.c
> >>> > > +++ b/drivers/hv/hv_balloon.c
> >>> > > @@ -1091,6 +1091,8 @@ static void balloon_up(struct
> work_struct
> >> > *dummy)
> >>> > >  	bool done = false;
> >>> > >  	int i;
> >>> > >
> >>> > > +	/* The host does balloon_up in 2MB. */
> >>> > > +	WARN_ON(num_pages % PAGES_IN_2M != 0);
> >>> > >
> >>> > >  	/*
> >>> > >  	 * We will attempt 2M allocations. However, if we fail to
> >>> > > @@ -1111,7 +1113,7 @@ static void balloon_up(struct
> work_struct
> >> > *dummy)
> >>> > >  						bl_resp, alloc_unit,
> >>> > >  						 &alloc_error);
> >>> > >
> >>> > > -		if ((alloc_error) && (alloc_unit != 1)) {
> >>> > > +		if (alloc_error && (alloc_unit != 1) &&
> num_ballooned == 0)
> >> > {
> >>> > >  			alloc_unit = 1;
> >>> > >  			continue;
> >>> > >  		}
> >> >
> >> > Before the change, we may retry the 4K allocation when part or all 2M
> >> > allocations were failed. This makes sense when memory is fragmented.
> But
> > Yes, but all the partially-allocated 2MB memory blocks are lost(mem leak).
> >
> >> > after the change, if part of 2M allocation were failed, we won't retry
> >> > 4K allocation. Is this expected?
> > Hi Jason,
> > The patch doesn't break the "try 2MB first; then try 4K" logic:
> >
> > With the change, we'll retry the 2MB allocation in the next iteration of the
> > same while (!done) loop -- we expect this retry will cause
> > "alloc_error && (alloc_unit != 1) && num_ballooned == 0" to be true,
> > so we'll later try 4K allocation, as we did before.
> 
> If I read the code correctly, if part of 2M allocation fails.
> alloc_balloon_pages() will have a non zero return value with alloc_error
> set. Then it will match the following check:
> 
>                 if ((alloc_error) || (num_ballooned == num_pages))
> {
> 
> which will set done to true. So there's no second iteration of while
> (!done) loop?
Oh... I see the issue in my patch.
Thanks for pointing this out, Jason!

> Probably you need something like:
> 
> if ((alloc_unit != 1) && (num_ballooned == 0)) {
>     alloc_unit = 1;
>     continue;
> }
> 
> if ((alloc_unit == 1) || (num_ballooned == num_pages)) {
>     ...
> }
Your code is good, except for one thing:
alloc_balloon_pages() can return due to:

if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
                         PAGE_SIZE)
                        return i * alloc_unit;

In this case, "alloc_unit == 1" is true, but we shouldn't run "done = true". 

How do you like this? I made a few changes based on your code.

@@ -1086,16 +1088,18 @@ static void balloon_up(struct work_struct *dummy)
                num_pages -= num_ballooned;
+               alloc_error = false;
                num_ballooned = alloc_balloon_pages(&dm_device, num_pages,
                                                bl_resp, alloc_unit,
                                                 &alloc_error);

-               if ((alloc_error) && (alloc_unit != 1)) {
+               if (alloc_unit != 1 && num_ballooned == 0) {
                        alloc_unit = 1;
                        continue;
                }

-               if ((alloc_error) || (num_ballooned == num_pages)) {
+               if ((alloc_unit == 1 && alloc_error) ||
+                       (num_ballooned == num_pages)) {
                        bl_resp->more_pages = 0;
                        done = true;
                        dm_device.state = DM_INITIALIZED;


If you're Ok with this, I'll send out a v2 patch.

Thanks,
-- Dexuan
