Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaFZU7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:59:14 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:46896
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511AbaFZU7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:59:13 -0400
From: "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>
CC: Dexuan Cui <decui@microsoft.com>, Thomas Shao <huishao@microsoft.com>
Subject: RE: [PATCH] Tools: hv: fix file overwriting of hv_fcopy_daemon
Thread-Topic: [PATCH] Tools: hv: fix file overwriting of hv_fcopy_daemon
Thread-Index: AQHPkXqZZW0ajKOuakqqjhOqmAPdk5uD2uTwgAADjEA=
Date: Thu, 26 Jun 2014 20:58:39 +0000
Message-ID: <DC7803B42427924284F2D5252E076A3B44728D11@SINEX14MBXC404.southpacific.corp.microsoft.com>
References: <1403816968-15419-1-git-send-email-yuezha@microsoft.com>
 <9aa07d3dad7c448da7ee7a3e007e0140@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <9aa07d3dad7c448da7ee7a3e007e0140@BY2PR03MB299.namprd03.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(13464003)(51704005)(189002)(199002)(107046002)(83322001)(19580395003)(77982001)(44976005)(26826002)(55846006)(6806004)(85852003)(83072002)(19580405001)(74502001)(79102001)(2201001)(92566001)(16796002)(31966008)(20776003)(92726001)(87936001)(47776003)(64706001)(85306003)(74662001)(106116001)(86362001)(77096002)(76482001)(86612001)(54356999)(80022001)(84676001)(81542001)(23726002)(99396002)(106466001)(81156004)(33656002)(95666004)(69596002)(21056001)(68736004)(81342001)(97756001)(97736001)(46102001)(76176999)(2656002)(1511001)(50986999)(50466002)(4396001)(46406003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB609;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 02543CD7CD
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=yuezha@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: KY Srinivasan
> > -----Original Message-----
> > From: Yue Zhang [mailto:yuezha@microsoft.com]
> > hv_fcopy_daemon fails to overwrite a file if the target file already exits.
> >
> > Add O_TRUNC flag on opening.
> >
> > Signed-off-by: Yue Zhang <yuezha@microsoft.com>
> > ---
> >  tools/hv/hv_fcopy_daemon.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
> > index fba1c75..01eee6b 100644
> > --- a/tools/hv/hv_fcopy_daemon.c
> > +++ b/tools/hv/hv_fcopy_daemon.c
> > @@ -88,7 +88,8 @@ static int hv_start_fcopy(struct hv_start_fcopy
> > *smsg)  }  }
> >
> > -target_fd = open(target_fname, O_RDWR | O_CREAT | O_CLOEXEC, 0744);
> > +target_fd = open(target_fname,
> > +O_RDWR | O_CREAT | O_TRUNC |
> Please align O_RDWR to align with the first argument (target_fname).
Thanks. I will fix it. 
> 
> K. Y
> 

