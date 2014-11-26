Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaKZWdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:33:49 -0500
Received: from mail-bl2on0136.outbound.protection.outlook.com ([65.55.169.136]:53957
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751240AbaKZWdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:33:47 -0500
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Alexander Graf <agraf@suse.de>, Jose Rivera <German.Rivera@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        "bhamciu1@freescale.com" <bhamciu1@freescale.com>,
        "R89243@freescale.com" <R89243@freescale.com>,
        Geoff Thorpe <Geoff.Thorpe@freescale.com>,
        "bhupesh.sharma@freescale.com" <bhupesh.sharma@freescale.com>,
        "nir.erez@freescale.com" <nir.erez@freescale.com>,
        Richard Schmitt <richard.schmitt@freescale.com>
Subject: RE: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
Thread-Topic: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
Thread-Index: AQHQCWH+izjvEAXJzUaTeK76eOkwuZxze4aw
Date: Wed, 26 Nov 2014 22:33:43 +0000
Message-ID: <CY1PR0301MB0748850351477C53D47A042087700@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com>
 <1415901246-24131-2-git-send-email-German.Rivera@freescale.com>
 <5475A85E.1080204@suse.de>
In-Reply-To: <5475A85E.1080204@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.168.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0650;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0650;
x-forefront-prvs: 04073E895A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(164054003)(189002)(24454002)(199003)(51704005)(377454003)(20776003)(4396001)(64706001)(40100003)(97736003)(2501002)(31966008)(77156002)(77096003)(62966003)(33656002)(101416001)(106116001)(105586002)(99286002)(106356001)(107046002)(86362001)(54206007)(21056001)(66066001)(92566001)(92726001)(2201001)(54606007)(76576001)(74316001)(19580395003)(95666004)(46102003)(50986999)(54356999)(76176999)(122556002)(87936001)(99396003)(19580405001)(120916001)(2656002)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0650;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alexander Graf [mailto:agraf@suse.de]
> Sent: Wednesday, November 26, 2014 4:16 AM
> To: Rivera Jose-B46482; gregkh@linuxfoundation.org; arnd@arndb.de; linux-kernel@vger.kernel.org
> Cc: Yoder Stuart-B08248; Phillips Kim-R1AAHA; Wood Scott-B07421; Hamciuc Bogdan-BHAMCIU1; Marginean
> Alexandru-R89243; Thorpe Geoff-R01361; Sharma Bhupesh-B45370; Erez Nir-RM30794; Schmitt Richard-B43082
> Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex APIs
> 
> 
> 
> On 13.11.14 18:54, J. German Rivera wrote:
> > APIs to access the Management Complex (MC) hardware
> > module of Freescale LS2 SoCs. This patch includes
> > APIs to check the MC firmware version and to manipulate
> > DPRC objects in the MC.
> >
> > Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> > Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> 
> [...]
> 
> > diff --git a/drivers/bus/fsl-mc/dprc.c b/drivers/bus/fsl-mc/dprc.c
> > new file mode 100644
> > index 0000000..40ae552
> > --- /dev/null
> > +++ b/drivers/bus/fsl-mc/dprc.c
> > @@ -0,0 +1,933 @@
> > +/* Copyright 2013-2014 Freescale Semiconductor Inc.
> > +*
> > +* Redistribution and use in source and binary forms, with or without
> > +* modification, are permitted provided that the following conditions are met:
> > +* * Redistributions of source code must retain the above copyright
> > +* notice, this list of conditions and the following disclaimer.
> > +* * Redistributions in binary form must reproduce the above copyright
> > +* notice, this list of conditions and the following disclaimer in the
> > +* documentation and/or other materials provided with the distribution.
> > +* * Neither the name of the above-listed copyright holders nor the
> > +* names of any contributors may be used to endorse or promote products
> > +* derived from this software without specific prior written permission.
> > +*
> > +*
> > +* ALTERNATIVELY, this software may be distributed under the terms of the
> > +* GNU General Public License ("GPL") as published by the Free Software
> > +* Foundation, either version 2 of that License or (at your option) any
> > +* later version.
> > +*
> > +* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
> > +* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> > +* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> > +* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
> > +* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> > +* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> > +* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
> > +* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
> > +* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> > +* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> > +* POSSIBILITY OF SUCH DAMAGE.
> > +*/
> > +#include <linux/fsl/mc-sys.h>
> > +#include <linux/fsl/mc-cmd.h>
> > +#include <linux/fsl/dprc.h>
> > +#include "dprc-cmd.h"
> > +
> > +int dprc_get_container_id(struct fsl_mc_io *mc_io, int *container_id)
> 
> This one is definitely a misnomer. It's a command that operates on the
> MC object, not a DPRC object. Also it doesn't fetch a random
> "container_id", it fetches the root container id.

It's not strictly the root container. It fetches the container/DPRC ID
associated with the portal you are using.  A virtual machine would use
it to fetch it's container ID.

> Please move it and its definition to the files that operate on the MC
> management interface.

Note, the binary interface opcode really is DPRC_CMDID_GET_CONT_ID.

We can request that the binary interface naming be changed, but wouldn't
it be better to keep the functions separated by opcode type-- having
DPRC_CMDID* opcode-based commands be in one file and DPMNG_CMDID* commands
in a separate file?

We have already submitted a request to move this opcode to the DPMNG
group.

Thanks,
Stuart


