Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaDDWyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:54:04 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:4763
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753488AbaDDWx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:53:56 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dave Young <dyoung@redhat.com>
Subject: RE: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
 legacy PIC
Thread-Topic: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
 legacy PIC
Thread-Index: AQHPT5v0hZTrqe/+3EGIeADAdCnXXZsBgI4AgAAKkDCAAAdUAIAAUY6AgAAGuQCAACaJQA==
Date: Fri, 4 Apr 2014 22:53:53 +0000
Message-ID: <1b39369f5f574577ae386256dd2d4c03@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1396574193-12043-1-git-send-email-kys@microsoft.com>
 <20140404141218.GA2161@redhat.com>
 <fb8d196a0c01479bae9c3669d8ea8be5@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140404151620.GB2161@redhat.com>
 <9a22bbc2850941819cd2c71a26c584d5@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140404203218.GA26102@redhat.com>
In-Reply-To: <20140404203218.GA26102@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.19.246.69]
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(13464003)(51704005)(24454002)(377454003)(33646001)(83072002)(85852003)(87936001)(46102001)(74366001)(99396002)(53806001)(74706001)(54356001)(99286001)(76482001)(56776001)(54316002)(98676001)(95416001)(79102001)(56816005)(90146001)(74662001)(92566001)(74876001)(80976001)(74502001)(31966008)(93136001)(74316001)(2656002)(87266001)(51856001)(81816001)(47446002)(81686001)(85306002)(83322001)(19580405001)(19580395003)(65816001)(66066001)(97336001)(4396001)(80022001)(93516002)(94946001)(49866001)(47736001)(86362001)(94316002)(86612001)(59766001)(77982001)(81542001)(76576001)(81342001)(47976001)(50986001)(76786001)(20776003)(63696002)(97186001)(76796001)(95666003)(69226001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:EDCF08E.A2F25F12.3CFF9BBE.4C79D868.2026C;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@redhat.com]
> Sent: Friday, April 4, 2014 1:32 PM
> To: KY Srinivasan
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; hpa@zytor.com;
> stable@vger.kernel.org; Dave Young
> Subject: Re: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
> legacy PIC
> 
> On Fri, Apr 04, 2014 at 08:09:47PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Vivek Goyal [mailto:vgoyal@redhat.com]
> > > Sent: Friday, April 4, 2014 8:16 AM
> > > To: KY Srinivasan
> > > Cc: x86@kernel.org; linux-kernel@vger.kernel.org; olaf@aepfle.de;
> > > apw@canonical.com; jasowang@redhat.com; hpa@zytor.com;
> > > stable@vger.kernel.org; Dave Young
> > > Subject: Re: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use
> > > NULL legacy PIC
> > >
> > > On Fri, Apr 04, 2014 at 03:01:51PM +0000, KY Srinivasan wrote:
> > >
> > > [..]
> > > > The problem we were having is that the initial boot on the EFI
> > > > firmware would succeed as the legacy PIC would be NULL legacy PIC,
> > > > however in the kexeced kernel, the initial boot information is not
> > > > available and so we would not set the legacy PIC to NULL legacy PIC.
> > >
> > > I am curious to know what "initial boot information" is not
> > > available in kexeced kernel and who is supposed to provide that.
> > >
> > > Is it a bug or that's how it is supposed to work.
> >
> > As the name indicates, the dump kernel is not "booted" but it is kexeced.
> > In the address space of this second kernel, the initial boot state is not
> visible.
> 
> What do you mean by "initial boot state"? Most of the state we pass to
> second kernel in bootparams and on command line and rest second kernel
> can query from firmware as needed.
Specifically, this check I had:
if (efi_enabled(EFI_BOOT)) {
}

Fails in the kexeced kernel even when running on EFI firmware.

K. Y
