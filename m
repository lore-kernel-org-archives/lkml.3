Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab3CMR1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:27:33 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:47363
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756411Ab3CMR1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:27:31 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: 1
X-BigFish: PS1(z551biz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah17ej9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH RESEND 5/6] Drivers: hv: balloon: Implement hot-add
 functionality
Thread-Topic: [PATCH RESEND 5/6] Drivers: hv: balloon: Implement hot-add
 functionality
Thread-Index: AQHOH0fSRgPPQZcXJkuyI21Iwo4J9Zij1x0AgAAI8vA=
Date: Wed, 13 Mar 2013 17:25:07 +0000
Message-ID: <7f6d3d717791402f8aad39238f0a5329@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1363111313-30201-1-git-send-email-kys@microsoft.com>
 <1363111342-30242-1-git-send-email-kys@microsoft.com>
 <1363111342-30242-5-git-send-email-kys@microsoft.com>
 <20130313165015.GC23945@aepfle.de>
In-Reply-To: <20130313165015.GC23945@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:e0:2027:146b:e7d3:de93:2cc1]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(189002)(377454001)(24454001)(13464002)(51704002)(79102001)(50986001)(47776003)(20776003)(16676001)(54356001)(69226001)(4396001)(5343635001)(50466001)(47446002)(80022001)(63696002)(76482001)(47736001)(54316002)(46102001)(56776001)(6806001)(49866001)(74662001)(56816002)(44976002)(33646001)(23676001)(77982001)(51856001)(65816001)(53806001)(47976001)(59766001)(74502001)(31966008)(3826001)(24736002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB018;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0784C803FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2DHRXWR024548



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Wednesday, March 13, 2013 12:50 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH RESEND 5/6] Drivers: hv: balloon: Implement hot-add
> functionality
> 
> On Tue, Mar 12, K. Y. Srinivasan wrote:
> 
> > Implement the memory hot-add functionality. With this, Linux guests can fully
> > participate in the Dynamic Memory protocol implemented in the Windows
> hosts.
> 
> > +++ b/drivers/hv/Kconfig
> > @@ -15,7 +15,7 @@ config HYPERV_UTILS
> >
> >  config HYPERV_BALLOON
> >  	tristate "Microsoft Hyper-V Balloon driver"
> > -	depends on HYPERV
> > +	depends on HYPERV && MEMORY_HOTPLUG
> >  	help
> >  	  Select this option to enable Hyper-V Balloon driver.
> 
> This driver now depends on CONFIG_MEMORY_HOTPLUG, which is disabled in
> openSuSE i386 kernel. As a result, the hv_balloon driver disappears for
> 32bit kernels.
> 
> Any chance that the Kconfig dependency can be moved inside the code so
> that a 32bit guest can still do balloon operations?

I can preserve the old behavior by getting rid of the config dependency and adding in
the MEMORY_HOTPLUG dependency around the affected code. Greg, shall I just re-send
this one patch.

Regards,

K. Y
> 
> 
> Olaf
> 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
