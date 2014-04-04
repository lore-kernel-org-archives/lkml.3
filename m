Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaDDULz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:11:55 -0400
Received: from [207.46.163.211] ([207.46.163.211]:26380 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752946AbaDDULx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:11:53 -0400
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
Thread-Index: AQHPT5v0hZTrqe/+3EGIeADAdCnXXZsBgI4AgAAKkDCAAAdUAIAAUY6A
Date: Fri, 4 Apr 2014 20:09:47 +0000
Message-ID: <9a22bbc2850941819cd2c71a26c584d5@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1396574193-12043-1-git-send-email-kys@microsoft.com>
 <20140404141218.GA2161@redhat.com>
 <fb8d196a0c01479bae9c3669d8ea8be5@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140404151620.GB2161@redhat.com>
In-Reply-To: <20140404151620.GB2161@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.19.246.69]
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(24454002)(51704005)(199002)(189002)(377454003)(74876001)(95666003)(50986001)(47976001)(19580405001)(74502001)(53806001)(54356001)(74706001)(19580395003)(74316001)(74366001)(97186001)(83322001)(69226001)(99396002)(31966008)(46102001)(80976001)(47736001)(98676001)(81686001)(86612001)(76576001)(86362001)(77982001)(94946001)(51856001)(47446002)(85852003)(94316002)(59766001)(65816001)(80022001)(93516002)(56816005)(20776003)(76796001)(66066001)(93136001)(63696002)(85306002)(83072002)(87266001)(97336001)(81542001)(99286001)(81342001)(54316002)(90146001)(81816001)(56776001)(4396001)(76482001)(74662001)(33646001)(76786001)(95416001)(2656002)(87936001)(49866001)(79102001)(92566001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:ECCF28E.92F25F12.3CFF07BF.4C65D868.201FC;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@redhat.com]
> Sent: Friday, April 4, 2014 8:16 AM
> To: KY Srinivasan
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; hpa@zytor.com;
> stable@vger.kernel.org; Dave Young
> Subject: Re: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
> legacy PIC
> 
> On Fri, Apr 04, 2014 at 03:01:51PM +0000, KY Srinivasan wrote:
> 
> [..]
> > The problem we were having is that the initial boot on the EFI
> > firmware would succeed as the legacy PIC would be NULL legacy PIC,
> > however in the kexeced kernel, the initial boot information is not
> > available and so we would not set the legacy PIC to NULL legacy PIC.
> 
> I am curious to know what "initial boot information" is not available in
> kexeced kernel and who is supposed to provide that.
> 
> Is it a bug or that's how it is supposed to work.

As the name indicates, the dump kernel is not "booted" but it is kexeced.
In the address space of this second kernel, the initial boot state is not visible.
This is the way it is supposed to work.

K. Y
> 
> Thanks
> Vivek
