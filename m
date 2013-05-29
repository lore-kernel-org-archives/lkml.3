Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934972Ab3E2CGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:06:09 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:15925
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934826Ab3E2CGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:06:07 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hz97hz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V2 0/2] Drivers: hv: vmbus: Implement multi-channel
 support 
Thread-Topic: [PATCH V2 0/2] Drivers: hv: vmbus: Implement multi-channel
 support 
Thread-Index: AQHOV+OC6LKX4jn0fUq8y5YmchY6LpkbcG5g
Date: Wed, 29 May 2013 02:05:38 +0000
Message-ID: <6ef7ca46d63649eca1da485c000773eb@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1369335730-16965-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1369335730-16965-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.56.200.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(13464003)(189002)(377454002)(51704005)(77982001)(44976003)(59766001)(4396001)(76482001)(50466002)(74876001)(54356001)(81342001)(74316001)(51856001)(54316002)(47446002)(33646001)(74502001)(20776003)(46102001)(16676001)(76576001)(49866001)(1511001)(50986001)(46406003)(56816002)(47976001)(69226001)(66066001)(23726002)(6806003)(47736001)(74706001)(81542001)(79102001)(74662001)(80022001)(65816001)(63696002)(74366001)(56776001)(31966008)(53806001)(47776003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB032;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 08617F610C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Thursday, May 23, 2013 3:02 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH V2 0/2] Drivers: hv: vmbus: Implement multi-channel support
> 
> This patch-set implements multi-channel support for Hyper-V devices.
> 
> Earlier, these two patches were sent out as part of a larger patch-set
> that included relevant changes in the storage driver.
> 
> In this version of the patch, I have fixed a race condition in the code that
> opens the sub-channels.
> 
> K. Y. Srinivasan (2):
>   Drivers: hv: vmbus: Implement multi-channel support
>   Drivers: hv: Add the GUID fot synthetic fibre channel device
> 
>  drivers/hv/channel.c      |   50 +++++++++++++++++--
>  drivers/hv/channel_mgmt.c |  119
> +++++++++++++++++++++++++++++++++++++++++++--
>  drivers/hv/connection.c   |   14 +++++
>  include/linux/hyperv.h    |   70 ++++++++++++++++++++++++++
>  4 files changed, 245 insertions(+), 8 deletions(-)

Greg,

You had acked the previous version of these patches that I had sent along with the storage driver
patches that used this infrastructure. We are going to be submitting network driver patches that will use
this infrastructure to implement VRSS (virtual receive side scaling) and that is the reason I chose to not tie
up these vmbus patches with the storvsc patches. Please let me know if you are ok with the changes I have
made in this version. Once these patches are committed, we will submit both storage and networking patches
that use this infrastructure.

Regards,

K. Y
> 
> --
> 1.7.4.1
> 
> 


