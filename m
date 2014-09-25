Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaIYJzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:55:41 -0400
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:61341
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750984AbaIYJzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:55:38 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>, Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Drivers: hv: util: Implement Time Synchronization using
 host time sample
Thread-Topic: [PATCH] Drivers: hv: util: Implement Time Synchronization
 using host time sample
Thread-Index: AQHP1vKMtDPVAvlpRESa+FlYjIeumZwOWccAgAMGX4CAADTtAA==
Date: Thu, 25 Sep 2014 09:40:42 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD84014154094643@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1411451081-13423-1-git-send-email-huishao@microsoft.com>
 <20140923075610.GA10933@aepfle.de> <20140925060745.GA9450@sucs.org>
In-Reply-To: <20140925060745.GA9450@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(189002)(51704005)(3905003)(199003)(377454003)(24454002)(13464003)(76176999)(50986999)(31966008)(44976005)(23726002)(106116001)(86146001)(55846006)(97756001)(15395725005)(85306004)(97736003)(15202345003)(83322001)(107046002)(69596002)(19580405001)(90102001)(16796002)(21056001)(19580395003)(106466001)(54356999)(6806004)(76482002)(68736004)(79102003)(66066001)(10300001)(84676001)(120916001)(47776003)(86612001)(33656002)(85852003)(92726001)(81542003)(2656002)(87936001)(83072002)(46102003)(77096002)(74502003)(20776003)(15975445006)(64706001)(81342003)(74662003)(77982003)(50466002)(80022003)(86362001)(46406003)(19300405004)(81156004)(4396001)(95666004)(92566001)(99396003)(562404015);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1211;H:mail.microsoft.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0345CFD558
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Thursday, September 25, 2014 2:08 PM
> To: Olaf Hering
> Cc: Thomas Shao; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: [PATCH] Drivers: hv: util: Implement Time Synchronization using
> host time sample
> 
> On Tue, Sep 23, 2014 at 09:56:10AM +0200, Olaf Hering wrote:
> > On Tue, Sep 23, Thomas Shao wrote:
> >
> > > In current hyper-v time sync service,it only gets the initial clock
> > > time from the host. It didn't process the following time samples.
> > > This change introduced a module parameter called host_time_sync. If
> > > it is set to true, the guest will periodically sychronize it's time
> > > with the host clock using host time sample. By default it is
> > > disabled, because we still recommend user to configure NTP for time
> synchronization.
> 
> You [Microsoft?] do? Can you link to public sources where is this stated
> please? I don't see any mention of doing this on
> http://technet.microsoft.com/en-us/library/dn720239.aspx .. The only
> official Microsoft information with respect to Hyper-V guest time
> synchronisation I've seen has been for Windows guests but perhaps I've
> looked in the wrong places.
> 
> The reason I ask is because regular ntpd is not enough to discipline a Linux
> Hyper-V guest's clock. So much drift can occur under load that ntpd can't
> bring the clock under sync. For now, I've been using Chrony which has a
> higher tolerance for correcting drifting clocks. I'm not the only one seeing this
> either (see http://serverfault.com/a/488528/203726
> and
> http://serverfault.com/questions/523389/linux-clock-loses-10-minutes-
> every-week
> ).
> 
> It would be good to something official about this issue as it is painful when
> happens.
> 

Hi Sitsofe,

As far as I know, currently the document about time sync in Hyper-V is only for Windows. Below is a doc from MSDN:
http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/11/19/time-synchronization-in-hyper-v.aspx 
We are working on the document about Time Sync on Hyper-V to cover both Linux and Windows.

> --
> Sitsofe | http://sucs.org/~sits/
