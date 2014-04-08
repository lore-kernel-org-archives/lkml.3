Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaDHNvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:51:51 -0400
Received: from mail-bn1bon0119.outbound.protection.outlook.com ([157.56.111.119]:53827
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756551AbaDHNvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:51:49 -0400
X-Greylist: delayed 57789 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 09:51:48 EDT
Message-ID: <1396965459.23349.4.camel@dinh-ubuntu>
Subject: Re: [PATCH 3/3] edac: altera: Add SDRAM EDAC support for
 CycloneV/ArriaV
From: Thor Thayer <tthayer@altera.com>
To: Borislav Petkov <bp@alien8.de>
CC: <robherring2@gmail.com>, <dougthompson@xmission.com>,
        <grant.likely@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <dinguyen@altera.com>, <devicetree@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 8 Apr 2014 08:57:39 -0500
In-Reply-To: <20140408100851.GF30077@pd.tnic>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
	 <1396907649-20212-4-git-send-email-tthayer@altera.com>
	 <20140408100851.GF30077@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?utf-8?B?Q0lQOjY2LjM1LjIzNi4yMzI7Q1RSWTpVUztJUFY6TkxJO0VGVjpOTEk7U0ZW?=
 =?utf-8?B?Ok5TUE07U0ZTOigxMDAxOTAwMSkoNjAwOTAwMSkoNDU4MDAxKSgyNDQ1NDAw?=
 =?utf-8?B?MikoNTE3MDQwMDUpKDE5OTAwMikoMTg5MDAyKSgzNzc0MjQwMDQpKDY4MDYw?=
 =?utf-8?B?MDQpKDk5Mzk2MDAyKSgxOTU4MDM5NTAwMykoNzkxMDIwMDEpKDQ2MTAyMDAx?=
 =?utf-8?B?KSg3NDg3NjAwMSkoNjI5NjYwMDIpKDU5NzY2MDAxKSg0MjE4NjAwNCkoNTY3?=
 =?utf-8?B?NzYwMDEpKDc2NDgyMDAxKSg3NDcwNjAwMSkoNDc3NzYwMDMpKDk1NDE2MDAx?=
 =?utf-8?B?KSg5NDMxNjAwMikoNjM2OTYwMDIpKDgwOTc2MDAxKSg5ODY3NjAwMSkoODc5?=
 =?utf-8?B?MzYwMDEpKDUwOTg2MDAxKSg4NjM2MjAwMSkoODgxMzYwMDIpKDU0MzE2MDAy?=
 =?utf-8?B?KSg4MTY4NjAwMSkoMjAwOTAwMSkoNzQ1MDIwMDEpKDU2ODE2MDA1KSg3Nzk4?=
 =?utf-8?B?MjAwMSkoNzQ2NjIwMDEpKDg1ODUyMDAzKSg5NDk0NjAwMSkoOTAxNDYwMDEp?=
 =?utf-8?B?KDgwMDIyMDAxKSg4MzA3MjAwMikoODE4MTYwMDEpKDgzMzIyMDAxKSgyMDc3?=
 =?utf-8?B?NjAwMykoOTcxODYwMDEpKDQ3OTc2MDAxKSg3NDM2NjAwMSkoOTczMzYwMDEp?=
 =?utf-8?B?KDc2Nzk2MDAxKSg5NTY2NjAwMykoNjkyMjYwMDEpKDkzNTE2MDAyKSg1MDIy?=
 =?utf-8?B?NjAwMSkoNDM5NjAwMSkoOTM5MTYwMDIpKDgxNTQyMDAxKSg3NzE1NjAwMSko?=
 =?utf-8?B?OTMxMzYwMDEpKDg3MjY2MDAxKSg1MDQ2NjAwMikoOTI1NjYwMDEpKDg3Mjg2?=
 =?utf-8?B?MDAxKSgyMzY3NjAwMikoNDQ5NzYwMDUpKDgxMzQyMDAxKSg3Njc4NjAwMSko?=
 =?utf-8?B?OTc3MzYwMDEpKDMzNjQ2MDAxKSg0NzQ0NjAwMikoNzcwOTYwMDEpKDMzNzE2?=
 =?utf-8?B?MDAxKSgxOTU4MDQwNTAwMSkoNDc3MzYwMDEpKDQ5ODY2MDAxKSg2NTgxNjAw?=
 =?utf-8?B?MSkoOTI3MjYwMDEpKDMxOTY2MDA4KSg4NTMwNjAwMikoODk5OTYwMDEpKDg0?=
 =?utf-8?B?Njc2MDAxKSgxNjc5NjAwMikoNTM4MDYwMDEpKDIxNzg3MzAwMSk7RElSOk9V?=
 =?utf-8?B?VDtTRlA6MTEwMjtTQ0w6MTtTUlZSOkJOMUFGRk8xMUhVQjAxMztIOlNKLUlU?=
 =?utf-8?B?RVhFREdFMDIuYWx0ZXJhLnByaXYuYWx0ZXJhLmNvbTtGUFI6MkRDREZFNkQu?=
 =?utf-8?B?QUREMjZGMkIuNzFFMTlGRkIuRENEOEVCRDEuMjAyMTg7TUxWOnNmdjtQVFI6?=
 =?utf-8?Q?InfoDomainNonexistent;A:1;MX:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 017589626D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 12:08 +0200, Borislav Petkov wrote:
> On Mon, Apr 07, 2014 at 04:54:09PM -0500, tthayer@altera.com wrote:
> > From: Thor Thayer <tthayer@altera.com>
> > 
> > Added EDAC support for reporting ECC errors of CycloneV
> > and ArriaV SDRAM controller.
> > - The SDRAM Controller registers are used by the FPGA bridge so
> >   these are accessed through the syscon interface.
> > - The configuration of the SDRAM memory size for the EDAC framework
> >   is discovered from the memory node of the device tree.
> > - Documentation of the bindings in devicetree/bindings/arm/altera/
> >   socfpga-sdram-edac.txt
> > - Correction of single bit errors, detection of double bit errors.
> 
> Before I go and take a look at this further, is anyone at Altera going
> to maintain this driver in case of bug reports and issues with it?

Yes, Altera has a group specifically supporting Linux drivers on the
Altera SoCs.

> 
> Also, I see patch 3/3. Are the other two related? I see they are
> devicetree additions and, as such, all three should go together...
> 

I was told that the device tree additions should be separate patches in
a series since the device tree additions go to a separate group for
approval.

