Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaBLQ4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:56:14 -0500
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:48175 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaBLQ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:56:12 -0500
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2014 11:56:11 EST
X-MXL-Hash: 52fba7ab3c9b6775-010e5c91708347d39c94a0957dfc74ec11657c63
X-MXL-Hash: 52fba4a50b34ee6c-3832125d0d43a3e6b33d48ddbf2af700330ce5ff
Date: Wed, 12 Feb 2014 11:43:08 -0500
From: Joe Lawrence <joe.lawrence@stratus.com>
To: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
CC: "prometheanfire@gentoo.org" <prometheanfire@gentoo.org>,
        "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>,
        Support <support@lsi.com>,
        DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "kernel@gentoo.org" <kernel@gentoo.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
Message-ID: <20140212114308.4f57a8b5@jlaw-desktop.mno.stratus.com>
In-Reply-To: <188de80a52694613b5a1a045d0658256@CO1PR07MB298.namprd07.prod.outlook.com>
References: <52EC60C3.1080103@gentoo.org>
	<20140203092409.63ffd9a0@jlaw-desktop.mno.stratus.com>
	<188de80a52694613b5a1a045d0658256@CO1PR07MB298.namprd07.prod.outlook.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.0 cv=ea+Kic4H c=1 sm=1 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a]
X-AnalysisOut: [=9YMJWpya49sA:10 a=_KQqW7t0BisA:10 a=BLceEmwcHowA:10 a=kj9]
X-AnalysisOut: [zAlcOel0A:10 a=uelBKuKpAAAA:8 a=pqWU5g0ZCoEA:10 a=XJ73DR3w]
X-AnalysisOut: [AAAA:8 a=7mOBRU54AAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 ]
X-AnalysisOut: [a=TSbVqHtbAAAA:8 a=NEAV23lmAAAA:8 a=wHLMOelHIfQHCc7tCCkA:9]
X-AnalysisOut: [ a=CjuIK1q_8ugA:10 a=g3Y4LtA3PwEA:10 a=kSViFEBMy1sA:10 a=W]
X-AnalysisOut: [eOa-AV5lc8A:10 a=jkObVMfX7fAA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014021214); S=0.200(2010122901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sreekanth,

There hasn't been much recent activity in
drivers/scsi/scsi_transport_sas.c, so I wasn't sure who could best
review the patch.

Dan Williams added sas_rphy_unlink() back in 2011, perhaps he can
remember why sas_bsg_remove wasn't performed there?

Regards,

-- Joe


On Wed, 12 Feb 2014 11:43:58 +0000
"Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com> wrote:

> Hi Joe,
> 
> May I known the status of this patch having subject
> "[PATCH] scsi_transport_sas: move bsg destructor into sas_rphy_remove".
> 
> I need the status of this patch as I am also observing the same WARNING call trace on latest 3.14.0-rc2+ kernel whenever we unload the mpt2sas/mpt3sas driver or whenever we unplug the drive attached to the HBA.
> But after applying yours patch, these WARNING call trace is not observed.
> 
> Regards,
> Sreekanth
> 
> >-----Original Message-----
> >From: Joe Lawrence [mailto:joe.lawrence@stratus.com]
> >Sent: Monday, February 03, 2014 7:54 PM
> >To: prometheanfire@gentoo.org
> >Cc: Nandigama, Nagalakshmi; Reddy, Sreekanth; Support; DL-MPT Fusion
> >Linux; linux-scsi@vger.kernel.org; JBottomley@parallels.com; linux-
> >kernel@vger.kernel.org; kernel@gentoo.org
> >Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
> >
> >On Fri, 31 Jan 2014 20:49:39 -0600
> >Matthew Thode <prometheanfire@gentoo.org> wrote:
> >
> >> I decided to pull a drive while it was in use out of laziness (it was
> >> open via luks, but not in actual use).  Got a fun trace as a result.
> >> Just thought you'd like to know :D
> >>
> >
> >Hi Matthew,
> >
> >The first trace looks a lot like what I see on mpt2sas driver removal [1].  I
> >posted a suggested fix back in Dec [2], which you might try, however it is not
> >reviewed at this point.
> >
> >[1] http://thread.gmane.org/gmane.linux.scsi/86237
> >[2] https://github.com/joe-
> >lawrence/linux/compare/scsi_transport_sas_sysfs_warning.patch
> >
> >Regards,
> >
> >-- Joe
> 

