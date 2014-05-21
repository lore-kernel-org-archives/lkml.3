Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaEUIzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:55:47 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:3316
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751919AbaEUIzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:55:44 -0400
From: Srikanth Thokala <srikanth.thokala@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH] PCI: Generic Configuration Access Mechanism support
Thread-Topic: [PATCH] PCI: Generic Configuration Access Mechanism support
Thread-Index: AQHPdMm0LwUiVtzlMECQdKE6yXuriJtKuefA
Date: Wed, 21 May 2014 08:54:02 +0000
References: <1400422125-2209-1-git-send-email-sthokal@xilinx.com>
 <4223392.yrWc3QAXY9@wuerfel>
 <CA+mB=1KsxjJR0Yswmo2y_Gej64OPZLddXxJ+qn8YOx7=_EsqeA@mail.gmail.com>
 <4459842.TR2Vcq3XUx@wuerfel>
In-Reply-To: <4459842.TR2Vcq3XUx@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <3cbd2d6c-20ba-49c2-af73-898ba28b5c9e@BN1BFFO11FD052.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(199002)(189002)(24454002)(377454003)(51704005)(13464003)(54356999)(76176999)(33646001)(50986999)(92726001)(50466002)(23726002)(21056001)(74502001)(46406003)(81342001)(31966008)(74662001)(83072002)(85852003)(92566001)(31696002)(77982001)(70736001)(81542001)(19580395003)(86362001)(19580405001)(87936001)(2656002)(44976005)(47776003)(20776003)(64706001)(99396002)(76482001)(74316001)(46102001)(97756001)(83322001)(4396001)(80022001)(53416003)(41533002);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB059;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=srikanth.thokala@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Wednesday, May 21, 2014 1:23 PM
> To: Srikanth Thokala
> Cc: Bjorn Helgaas; will.deacon@arm.com; Michal Simek; linux-
> kernel@vger.kernel.org; linux-pci@vger.kernel.org
> Subject: Re: [PATCH] PCI: Generic Configuration Access Mechanism support
>
> On Tuesday 20 May 2014 20:01:01 Srikanth Thokala wrote:
> > On Mon, May 19, 2014 at 10:33 PM, Arnd Bergmann <arnd@arndb.de>
> wrote:
> > > On Sunday 18 May 2014 19:38:45 Srikanth Thokala wrote:
> > >> +
> > >> +     if (cfg->ops->is_valid_cfg_access) {
> > >> +             if (!cfg->ops->is_valid_cfg_access(bus, devfn)) {
> > >> +                     *val = PCI_CFG_INVALID_DEVFN;
> > >> +                     return PCIBIOS_DEVICE_NOT_FOUND;
> > >> +             }
> > >> +     }
> > >
> > > Can you explain why this callback is needed? If the space for the
> > > bus is mapped, any access should just work.
> >
> > As I was explaining to Will, there are some controllers which doesn't
> > return FF's when a device is not found on the bus (as per the PCI
> > specification) and accessing such a device address from the kernel
> > results in an external abort.
> > So, I added this additional logic in my driver to bypass this and
> > return FF's. Our IP and even other controllers like Tegra, Renesas
> > have similar implementation.
> > We cant think of a better solution and please let you us know if you
> > have any inputs.
>
> Does your hardware need this? My first response would otherwise be to
> treat that as noncompliant and not handle this case in the generic
> implementation.

Yes, my hardware needs this additional logic.

Srikanth

>
>       Arnd


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

