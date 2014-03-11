Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaCKAmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:42:40 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:16704
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751802AbaCKAmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:42:38 -0400
From: KY Srinivasan <kys@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V3 0/6] Drivers: net: hyperv: Enable various offloads 
Thread-Topic: [PATCH V3 0/6] Drivers: net: hyperv: Enable various offloads 
Thread-Index: AQHPOz+BqGcvO45D0kyYCZ0Swx0l4ZravwKAgABPodA=
Date: Tue, 11 Mar 2014 00:42:35 +0000
Message-ID: <8a794a772a8044d9bd3a22197da57945@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1394335362-11126-1-git-send-email-kys@microsoft.com>
 <20140310.155557.1576514754598895473.davem@davemloft.net>
In-Reply-To: <20140310.155557.1576514754598895473.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.141.86.4]
x-forefront-prvs: 0147E151B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377454003)(199002)(189002)(13464003)(87266001)(81816001)(90146001)(4396001)(19580405001)(83322001)(85852003)(56816005)(33646001)(81542001)(47976001)(49866001)(47736001)(81686001)(85306002)(50986001)(47446002)(2656002)(92566001)(80976001)(19580395003)(31966008)(83072002)(95416001)(87936001)(74502001)(74662001)(59766001)(95666003)(54356001)(93516002)(53806001)(94316002)(76576001)(79102001)(86362001)(97336001)(97186001)(69226001)(74876001)(74706001)(74316001)(51856001)(93136001)(20776003)(77982001)(81342001)(94946001)(76786001)(63696002)(46102001)(76796001)(76482001)(56776001)(80022001)(74366001)(54316002)(66066001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB026;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:EAEEF10E.BC339D2A.B4F13F9F.91EA39.202A5;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Tuesday, March 11, 2014 1:26 AM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH V3 0/6] Drivers: net: hyperv: Enable various offloads
> 
> From: "K. Y. Srinivasan" <kys@microsoft.com>
> Date: Sat,  8 Mar 2014 19:22:42 -0800
> 
> > This patch set enables both checksum as well as segmentation offload.
> > As part of this effort I have enabled scatter gather I/O a well.
> >
> > In version 2 of these patches, I addressed comments from David Miller
> > and Dan Carpenter.
> >
> > In this version I have addressed the latest comments from David Miller.
> 
> Series applied, thanks.
> 
> I still think that fill_pg_buf() could be improved.
> 
> For example, it returns '1' if len is passed in as zero.  Maybe that can't
> happen, but if it does the page buffer array will be corrupted and the driver
> will process garbage.
> 
> It seems so much more straightforward to me if you simply incremented 'j' in
> the loop when an array entry is actually filled in.  Then just return 'j'.
> 
> 	int j; 
>  ...
> 		pb[j].pfn = page_to_pfn(page);
> 		pb[j].offset = offset;
> 		pb[j].len = bytes;
> 		j++;
>  ...
> 	return j;
> 
> 
> Then 'j' is unambiguously the number of pb array entries which were filled in,
> no matter what.
Thanks David. As you suggest, I will send a patch to make this cleaner.

Regards,

K. Y
