Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaBLQsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:48:47 -0500
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:6514
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaBLQsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:48:45 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Tools: hv: vssdaemon: Ignore VFAT mounts during the
 Freeze operation
Thread-Topic: [PATCH 1/1] Tools: hv: vssdaemon: Ignore VFAT mounts during
 the Freeze operation
Thread-Index: AQHPKAoExIcYcWYIbkCBgB0wPGX3Gpqx0puAgAAA7JA=
Date: Wed, 12 Feb 2014 16:48:42 +0000
Message-ID: <6693126ee2ec4cab8de693b753fb987c@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1392223222-18037-1-git-send-email-kys@microsoft.com>
 <20140212164157.GC22377@kroah.com>
In-Reply-To: <20140212164157.GC22377@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.19.246.69]
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(13464003)(51704005)(24454002)(377454003)(189002)(199002)(2656002)(81686001)(74706001)(87266001)(95666001)(87936001)(53806001)(85852003)(92566001)(69226001)(86612001)(54316002)(56776001)(31966008)(80976001)(81816001)(54356001)(76482001)(74662001)(47446002)(74502001)(74876001)(81542001)(46102001)(74316001)(50986001)(65816001)(51856001)(76796001)(47976001)(49866001)(81342001)(90146001)(47736001)(66066001)(94946001)(79102001)(4396001)(56816005)(86362001)(77982001)(59766001)(93516002)(85306002)(63696002)(76576001)(74366001)(94316002)(76786001)(83322001)(80022001)(83072002)(95416001)(19580405001)(93136001)(33646001)(19580395003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:24.19.246.69;FPR:A9DEF556.8EA3FC0B.BDF105DC.845B39E2.20247;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, February 12, 2014 8:42 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Tools: hv: vssdaemon: Ignore VFAT mounts during the
> Freeze operation
> 
> On Wed, Feb 12, 2014 at 08:40:22AM -0800, K. Y. Srinivasan wrote:
> > If the guest has a FAT file system mounted, skip it during the FREEZE
> > operation. With this change we can support host initiated backup of
> > the guest even when the guest may have FAT file systems mounted.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  tools/hv/hv_vss_daemon.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> > index 520de3304..6a213b8 100644
> > --- a/tools/hv/hv_vss_daemon.c
> > +++ b/tools/hv/hv_vss_daemon.c
> > @@ -87,6 +87,8 @@ static int vss_operate(int operation)
> >  			continue;
> >  		if (strcmp(ent->mnt_type, "iso9660") == 0)
> >  			continue;
> > +		if (strcmp(ent->mnt_type, "vfat") == 0)
> > +			continue;
> 
> Why should the filesystem type matter here at all?

As part of snapshotting the guest, we want to freeze all mounted file systems in the guest.
FAT file system does not support the freeze operation and so we want to skip these mount
points. For VMs on UEFI firmware, the EFI partition is a FAT partition.

Regards,

K. Y
