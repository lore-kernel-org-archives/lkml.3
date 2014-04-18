Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaDRNIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:08:48 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:30074
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754329AbaDRNIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:08:40 -0400
X-WSS-ID: 0N489U1-07-EB0-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Matthias Graf <matthias.graf@st.ovgu.de>, Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: RE: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
Thread-Topic: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
Thread-Index: AQHPWucYTLQRL6J1bEOOa5Tp0ZNlCZsXYxaAgAAhnQD//9NH0A==
Date: Fri, 18 Apr 2014 13:08:24 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D040EE8218@satlexdag05.amd.com>
References: <532C727F.1080803@st.ovgu.de> <20140321172742.GA2846@pd.tnic>
 <532C97DF.9010201@st.ovgu.de> <20140321201352.GC1338@pd.tnic>
 <533069E4.10002@st.ovgu.de> <533C1B47.8080709@st.ovgu.de>
 <20140416142232.GF16741@pd.tnic> <534F73F6.7050804@st.ovgu.de>
 <20140417130207.GB4321@pd.tnic> <5350EDAE.8020101@st.ovgu.de>
 <20140418094523.GB4385@pd.tnic> <53511066.70005@st.ovgu.de>
In-Reply-To: <53511066.70005@st.ovgu.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(51914003)(24454002)(5423002)(51704005)(189002)(199002)(377454003)(13464003)(52044002)(97736001)(50986999)(19580395003)(83322001)(55846006)(2009001)(76176999)(99396002)(54356999)(4396001)(50466002)(53416003)(19580405001)(76482001)(44976005)(20776003)(80976001)(80022001)(23676002)(81542001)(92566001)(2656002)(92726001)(15975445006)(84676001)(77982001)(86362001)(47776003)(46102001)(33656001)(85852003)(74502001)(31966008)(74662001)(81342001)(83072002)(87936001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB113;H:atltwp01.amd.com;FPR:FCC3FEEE.A1DAD5A1.39F09F47.5FC4E8E9.20522;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 018577E36E
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3ID8vFq020662

> -----Original Message-----
> From: Matthias Graf [mailto:matthias.graf@st.ovgu.de]
> Sent: Friday, April 18, 2014 7:46 AM
> To: Borislav Petkov
> Cc: linux-kernel@vger.kernel.org; Tony Luck; Deucher, Alexander
> Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
> 
> I applied your patch to linus' current master (3.15.0-rc1+) and indeed
> it does solve the issue for me!
> 
> Thanks for your help.
> 
> I would appreciated if you keep me posted on updates.

You can try some testing patches here:
https://bugs.freedesktop.org/show_bug.cgi?id=76286

but for now, I'm just going to disable dpm on rv770 asics.

Alex

> 
> Best,
> Matthias
> 
> Am 18.04.2014 11:45, schrieb Borislav Petkov:
> > On Fri, Apr 18, 2014 at 11:17:34AM +0200, Matthias Graf wrote:
> >> Fine-grained bisection result:
> >>
> >> ab70b1dde73ff4525c3cd51090c233482c50f217 is the first bad commit
> >> commit ab70b1dde73ff4525c3cd51090c233482c50f217
> >> Author: Alex Deucher <alexander.deucher@amd.com>
> >> Date:   Fri Nov 1 15:16:02 2013 -0400
> >>
> >>     drm/radeon: enable DPM by default on r7xx asics
> >>
> >>     Seems to be stable on them.
> >>
> >>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> >>
> >> :040000 040000 f3262029b868df4d882f64b4deba6b9230e307ea
> >> 1f1dfca42763703a56e3cc82bb103608a24be94e M	drivers
> >>
> >>
> >> Result is reasonable: I have a RV770 chip.
> >
> > Yes it is.
> >
> >> (Additional) Bug Report for Reference:
> >> https://bugzilla.redhat.com/show_bug.cgi?id=1085785
> >>
> >> Thanks for the instructions Borislav! At first, I was not completely
> >> sure what you expected me to do (this is my first kernel bug report :)).
> >
> > And you're doing good so far! :-)
> >
> >> If there is anymore more I can help you with, let me know.
> >
> > Ok, now we want to confirm that this patch is *actually* the culprit by
> > reverting it. Simply pull Linus' master branch to have the latest tree,
> > and then do:
> >
> > $ git checkout -b radeon-revert master
> >
> > so that you land on a throwaway branch where we can play. Then normally
> you
> > would do
> >
> > $ git revert ab70b1dde73ff4525c3cd51090c233482c50f217
> >
> > but that causes conflicts so I did it for you, see below. Simply apply
> > this patch ontop *without* doing the revert with git. Then build, boot
> > and test. We want to see whether it still generates those ROB timeout
> > machine checks. If all looks ok, then we're pretty sure we need to talk
> > about DPM with your GPU on your platform with Alex. :-)
> >
> > Feel free to ask any questions should something be not clear.
> >
> > Thanks.
> >
> > ---
> > From 0790e872f6d3c986d9ed36b850fd9d799dc422f9 Mon Sep 17 00:00:00
> 2001
> > From: Borislav Petkov <bp@suse.de>
> > Date: Fri, 18 Apr 2014 11:43:12 +0200
> > Subject: [PATCH] Revert "drm/radeon: enable DPM by default on r7xx
> asics"
> >
> > This reverts commit ab70b1dde73ff4525c3cd51090c233482c50f217.
> >
> > Conflicts:
> > 	drivers/gpu/drm/radeon/radeon_pm.c
> > ---
> >  drivers/gpu/drm/radeon/radeon_pm.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/radeon/radeon_pm.c
> b/drivers/gpu/drm/radeon/radeon_pm.c
> > index ee738a524639..af693c4746da 100644
> > --- a/drivers/gpu/drm/radeon/radeon_pm.c
> > +++ b/drivers/gpu/drm/radeon/radeon_pm.c
> > @@ -1257,6 +1257,10 @@ int radeon_pm_init(struct radeon_device *rdev)
> >  	case CHIP_RV670:
> >  	case CHIP_RS780:
> >  	case CHIP_RS880:
> > +	case CHIP_RV770:
> > +	case CHIP_RV730:
> > +	case CHIP_RV710:
> > +	case CHIP_RV740:
> >  	case CHIP_BARTS:
> >  	case CHIP_TURKS:
> >  	case CHIP_CAICOS:
> > @@ -1273,10 +1277,6 @@ int radeon_pm_init(struct radeon_device *rdev)
> >  		else
> >  			rdev->pm.pm_method = PM_METHOD_PROFILE;
> >  		break;
> > -	case CHIP_RV770:
> > -	case CHIP_RV730:
> > -	case CHIP_RV710:
> > -	case CHIP_RV740:
> >  	case CHIP_CEDAR:
> >  	case CHIP_REDWOOD:
> >  	case CHIP_JUNIPER:
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
