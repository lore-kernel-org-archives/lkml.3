Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbaDHNye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:54:34 -0400
Received: from mail-bl2on0110.outbound.protection.outlook.com ([65.55.169.110]:57189
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756704AbaDHNyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:54:32 -0400
Message-ID: <1396965610.23349.7.camel@dinh-ubuntu>
Subject: Re: [PATCH 3/3] edac: altera: Add SDRAM EDAC support for
 CycloneV/ArriaV
From: Thor Thayer <tthayer@altera.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Mark Rutland <mark.rutland@arm.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@altera.com" <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 8 Apr 2014 09:00:10 -0500
In-Reply-To: <20140408124541.GA16054@pengutronix.de>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
	 <1396907649-20212-4-git-send-email-tthayer@altera.com>
	 <20140408104525.GA11876@e106331-lin.cambridge.arm.com>
	 <20140408124541.GA16054@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?utf-8?B?Q0lQOjY2LjM1LjIzNi4yMzI7Q1RSWTpVUztJUFY6TkxJO0VGVjpOTEk7U0ZW?=
 =?utf-8?B?Ok5TUE07U0ZTOigxMDAxOTAwMSkoNjAwOTAwMSkoNDU4MDAxKSgyNDQ1NDAw?=
 =?utf-8?B?MikoMTg5MDAyKSg1MTcwNDAwNSkoMTk5MDAyKSgzNzc0MjQwMDQpKDc0NjYy?=
 =?utf-8?B?MDAxKSg5MjcyNjAwMSkoOTM1MTYwMDIpKDIzNjc2MDAyKSg1NjgxNjAwNSko?=
 =?utf-8?B?NzkxMDIwMDEpKDk0MzE2MDAyKSg3Njc5NjAwMSkoNjkyMjYwMDEpKDk5Mzk2?=
 =?utf-8?B?MDAyKSgyMDA5MDAxKSg4NDY3NjAwMSkoNjM2OTYwMDIpKDgzMDcyMDAyKSg3?=
 =?utf-8?B?NzE1NjAwMSkoNzY3ODYwMDEpKDgxMzQyMDAxKSg0Mzk2MDAxKSgzMzcxNjAw?=
 =?utf-8?B?MSkoNTAyMjYwMDEpKDMzNjQ2MDAxKSg1MDQ2NjAwMikoOTQ5NDYwMDEpKDgx?=
 =?utf-8?B?Njg2MDAxKSg5NzczNjAwMSkoMzE5NjYwMDgpKDg2MzYyMDAxKSg5ODY3NjAw?=
 =?utf-8?B?MSkoNDc3MzYwMDEpKDU0MzE2MDAyKSg3NDcwNjAwMSkoNzQ4NzYwMDEpKDg3?=
 =?utf-8?B?Mjg2MDAxKSg3NjQ4MjAwMSkoODE1NDIwMDEpKDg1ODUyMDAzKSg5MzkxNjAw?=
 =?utf-8?B?MikoODMzMjIwMDEpKDY1ODE2MDAxKSg4NzkzNjAwMSkoMTk1ODAzOTUwMDMp?=
 =?utf-8?B?KDg1MzA2MDAyKSg4MTgxNjAwMSkoODk5OTYwMDEpKDQ3Nzc2MDAzKSg2ODA2?=
 =?utf-8?B?MDA0KSg2Mjk2NjAwMikoNDc5NzYwMDEpKDc3MDk2MDAxKSg1MDk4NjAwMSko?=
 =?utf-8?B?NDIxODYwMDQpKDc0MzY2MDAxKSg0NzQ0NjAwMikoNDk4NjYwMDEpKDc3OTgy?=
 =?utf-8?B?MDAxKSg5NzMzNjAwMSkoOTMxMzYwMDEpKDQ0OTc2MDA1KSgxOTU4MDQwNTAw?=
 =?utf-8?B?MSkoOTcxODYwMDEpKDgwOTc2MDAxKSg3NDUwMjAwMSkoMTY3OTYwMDIpKDg3?=
 =?utf-8?B?MjY2MDAxKSg5MDE0NjAwMSkoNDYxMDIwMDEpKDkyNTY2MDAxKSg5NTY2NjAw?=
 =?utf-8?B?MykoNTM4MDYwMDEpKDU5NzY2MDAxKSg4MDAyMjAwMSkoODgxMzYwMDIpKDIw?=
 =?utf-8?B?Nzc2MDAzKSg1Njc3NjAwMSkoOTU0MTYwMDEpKDIxNzg3MzAwMSk7RElSOk9V?=
 =?utf-8?B?VDtTRlA6MTEwMjtTQ0w6MTtTUlZSOkJOMUFGRk8xMUhVQjAyMztIOlNKLUlU?=
 =?utf-8?B?RVhFREdFMDIuYWx0ZXJhLnByaXYuYWx0ZXJhLmNvbTtGUFI6QURDNUZFNUQu?=
 =?utf-8?B?QUNEOEVCOTkuNzhGMDlENzMuOTJGNkVBRjYuMjAzNUY7TUxWOnNmdjtQVFI6?=
 =?utf-8?Q?InfoDomainNonexistent;MX:1;A:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 017589626D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 14:45 +0200, Steffen Trumtrar wrote:
> On Tue, Apr 08, 2014 at 11:45:25AM +0100, Mark Rutland wrote:
> > On Mon, Apr 07, 2014 at 10:54:09PM +0100, tthayer@altera.com wrote:
> > > From: Thor Thayer <tthayer@altera.com>
> > > 
> > > Added EDAC support for reporting ECC errors of CycloneV
> > > and ArriaV SDRAM controller.
> > > - The SDRAM Controller registers are used by the FPGA bridge so
> > >   these are accessed through the syscon interface.
> > > - The configuration of the SDRAM memory size for the EDAC framework
> > >   is discovered from the memory node of the device tree.
> > > - Documentation of the bindings in devicetree/bindings/arm/altera/
> > >   socfpga-sdram-edac.txt
> > > - Correction of single bit errors, detection of double bit errors.
> > > 
> > > Signed-off-by: Thor Thayer <tthayer@altera.com>
> > > To: Rob Herring <robherring2@gmail.com>
> > > To: Doug Thompson <dougthompson@xmission.com>
> > > To: Grant Likely <grant.likely@linaro.org>
> > > Cc: Dinh Nguyen <dinguyen@altera.com>
> > > Cc: devicetree@vger.kernel.org
> > > Cc: linux-edac@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  drivers/edac/Kconfig          |    9 ++
> > >  drivers/edac/Makefile         |    2 +
> > >  drivers/edac/altera_mc_edac.c |  360 +++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 371 insertions(+)
> > >  create mode 100644 drivers/edac/altera_mc_edac.c
> > 
> > [...]
> > 
> > > +/* Get total memory size from Open Firmware DTB */
> > > +static u32 altr_sdram_get_total_mem_size(void)
> > > +{
> > > +       struct device_node *np;
> > > +       u32 retcode, reg_array[2];
> > > +
> > > +       np = of_find_node_by_type(NULL, "memory");
> > > +       if (!np)
> > > +               return 0;
> > > +
> > > +       retcode = of_property_read_u32_array(np, "reg",
> > > +                                            reg_array, ARRAY_SIZE(reg_array));
> > 
> > There's no requirement that #address-cells = <1> or #size-cells = <1>,
> > even if any values in either would fit into 32 bits. If we must read
> > this from the DTB rather than elsewhere, please check
> > of_n_{addr,size}_cells.
> > 
> > Additionally, it's possible that the physical memory might be described
> > over multiple reg entries, or multiple memory nodes for some arbitrary
> > reason.
> > 
> > Can we not get this info from elsewhere rather than having to parse the
> > memory node within a driver?
> > 
> 
> It should be possible to calculate this from the dramaddrw register in the
> SDRAM controller.

Thank you all for the comments. I will look into this further.

> 
> Regards,
> Steffen
> 

