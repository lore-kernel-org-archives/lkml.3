Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaIZG6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:58:19 -0400
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:48908
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752968AbaIZG6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:58:18 -0400
X-Greylist: delayed 76613 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2014 02:58:18 EDT
From: Thomas Shao <huishao@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: Time keeps on slipping... on Hyper-V
Thread-Topic: Time keeps on slipping... on Hyper-V
Thread-Index: AQHP2MSs3f6Dn2FF4EqEMJgPvPUmjJwS92Og
Date: Fri, 26 Sep 2014 06:57:31 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD8401415409741D@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1411451081-13423-1-git-send-email-huishao@microsoft.com>
 <20140923075610.GA10933@aepfle.de> <20140925060745.GA9450@sucs.org>
 <CD2CABCB2C0A0D4682C5F8AD84014154094643@HKXPRD3002MB006.064d.mgd.msft.net>
 <20140925132055.GA13108@sucs.org>
In-Reply-To: <20140925132055.GA13108@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(438002)(377454003)(24454002)(199003)(51704005)(189002)(13464003)(31966008)(16796002)(15395725005)(86146001)(1411001)(10300001)(76482002)(120916001)(4396001)(26826002)(95666004)(23676002)(50986999)(93886004)(50466002)(85306004)(54356999)(15202345003)(76176999)(106466001)(84676001)(106116001)(6806004)(2656002)(21056001)(81156004)(19580405001)(97736003)(19580395003)(55846006)(15975445006)(87936001)(33656002)(64706001)(92726001)(92566001)(86362001)(47776003)(86612001)(107046002)(20776003)(90102001)(46102003)(69596002)(74502003)(74662003)(80022003)(83072002)(77982003)(85852003)(44976005)(77096002)(110136001)(79102003)(83322001)(66066001)(68736004)(99396003)(81342003)(81542003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1206;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1206;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8Q6wZ4W028311



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Sitsofe Wheeler
> Sent: Thursday, September 25, 2014 9:28 PM
> To: Thomas Shao
> Cc: Olaf Hering; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> driverdev-devel@linuxdriverproject.org; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: Time keeps on slipping... on Hyper-V
> 
> On Thu, Sep 25, 2014 at 09:40:42AM +0000, Thomas Shao wrote:
> > > > On Tue, Sep 23, Thomas Shao wrote:
> > > >
> > > > with the host clock using host time sample. By default it is
> > > > disabled, because we still recommend user to configure NTP for
> > > > time
> > >
> > > -----Original Message-----
> > > From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> > > Sent: Thursday, September 25, 2014 2:08 PM
> > >
> > > You [Microsoft?] do? Can you link to public sources where is this
> > > stated
> >
> > As far as I know, currently the document about time sync in Hyper-V is
> > only for Windows. Below is a doc from MSDN:
> > http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/11/19/time-synchro
> > nization-in-hyper-v.aspx
> 
> That post is problematic and not quite enough because it doesn't say "we
> recommend you always configure an external time source for a guest" but
> rather gives a more complicated statement saying "because guest time drifts
> we have a time synchronisation service that will sort things out.
> If you happen to be running a domain controller we recommend you configure
> regular synchronisation to an external time source in addition". This leads to
> questions like: if my (Linux) guest's sole purpose is to run a web server am I in
> the domain controller situation (domain controllers have to re-serve time so
> perhaps they are special)?
> It also doesn't cover the "clock drift is so bad ntpd can't correct it"
> issue.
> 
> Have you seen this document on TechNet -
> http://blogs.technet.com/b/enterprise_admin/archive/2010/04/04/linux-on-hy
> per-v-timesync.aspx
> "With the new Integration Services, Linux virtual machines can!
> 
> TimeSync means that you donâ€™t have to hassle with configur[ing]
> network-based time sync for your Linux VMs on Hyper-Vâ€¦they can get the
> correct time from the host!"
> 
> This document gives simpler advice looks quite compelling at first glance.
> 
> > We are working on the document about Time Sync on Hyper-V to cover
> > both Linux and Windows.
> 
> The sooner you can get such an official document out the better. All sources of
> guest time synchronisation information (including Microsoft blogs and
> non-Microsoft Q&A sites) need updating so they say the same
> (correct!) thing in a clear way.
> 
> For the meantime can you state what you believe the recommend practice is
> for Linux Hyper-V guests with regards to time synchronisation?
> 

We still recommend user to configure NTP in the guest VM. With the new time sync feature in this patch, 
you could have one more option to enable the guest-host sync, if the NTP didn't work in the environment.
For example the guest VM didn't have network connection.

> --
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
