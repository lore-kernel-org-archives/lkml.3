Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbaDHVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:09:59 -0400
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:32612
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756761AbaDHVJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:09:56 -0400
Message-ID: <1396991747.5499.3.camel@dinh-ubuntu>
Subject: Re: [PATCH 3/3] edac: altera: Add SDRAM EDAC support for
 CycloneV/ArriaV
From: Thor Thayer <tthayer@altera.com>
To: Borislav Petkov <bp@alien8.de>
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
Date: Tue, 8 Apr 2014 16:15:47 -0500
In-Reply-To: <20140408162213.GL30077@pd.tnic>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
	 <1396907649-20212-4-git-send-email-tthayer@altera.com>
	 <20140408100851.GF30077@pd.tnic> <1396965459.23349.4.camel@dinh-ubuntu>
	 <20140408152406.GI30077@pd.tnic>
	 <20140408154017.GF11876@e106331-lin.cambridge.arm.com>
	 <20140408160351.GK30077@pd.tnic>
	 <20140408161054.GA26210@e106331-lin.cambridge.arm.com>
	 <20140408162213.GL30077@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?utf-8?B?Q0lQOjY2LjM1LjIzNi4yMzI7Q1RSWTpVUztJUFY6TkxJO0VGVjpOTEk7U0ZW?=
 =?utf-8?B?Ok5TUE07U0ZTOigxMDAxOTAwMSkoNjAwOTAwMSkoNDU4MDAxKSg1MTkxNDAw?=
 =?utf-8?B?MykoMjQ0NTQwMDIpKDUxNzA0MDA1KSgzNzc0MjQwMDQpKDE4OTAwMikoMTk5?=
 =?utf-8?B?MDAyKSg0Nzc3NjAwMykoMjA3NzYwMDMpKDc5MTAyMDAxKSg2ODA2MDA0KSg0?=
 =?utf-8?B?NDk3NjAwNSkoOTc3MzYwMDEpKDc3MTU2MDAxKSg3NzA5NjAwMSkoODc5MzYw?=
 =?utf-8?B?MDEpKDg1MzA2MDAyKSg4MTM0MjAwMSkoODMzMjIwMDEpKDgwOTc2MDAxKSgy?=
 =?utf-8?B?MzY3NjAwMikoNzQ2NjIwMDEpKDMxOTY2MDA4KSg4NzI4NjAwMSkoODMwNzIw?=
 =?utf-8?B?MDIpKDE2Nzk2MDAyKSg4NTg1MjAwMykoODcyNjYwMDEpKDU2Nzc2MDAyKSg0?=
 =?utf-8?B?Nzk3NjAwMykoNzQ1MDIwMDEpKDc0MzY2MDAxKSg5MDE0NjAwMSkoODk5OTYw?=
 =?utf-8?B?MDEpKDgxNjg2MDAxKSg3NDcwNjAwMSkoODE4MTYwMDEpKDgxNTQyMDAxKSg3?=
 =?utf-8?B?NDg3NjAwMSkoNTA0NjYwMDIpKDg4MTM2MDAyKSg2OTIyNjAwMSkoNDYxMDIw?=
 =?utf-8?B?MDEpKDgwMDIyMDAxKSg4NDY3NjAwMSkoOTQ5NDYwMDEpKDk3MTg2MDAxKSg3?=
 =?utf-8?B?Njc4NjAwMSkoNzY3OTYwMDEpKDk1NjY2MDAzKSg5MzEzNjAwMSkoOTQzMTYw?=
 =?utf-8?B?MDIpKDk3MzM2MDAxKSg5MjU2NjAwMSkoODYzNjIwMDEpKDkzNTE2MDAyKSg5?=
 =?utf-8?B?MzkxNjAwMikoOTI3MjYwMDEpKDQ3NzM2MDAyKSgzMzY0NjAwMSkoNzc5ODIw?=
 =?utf-8?B?MDEpKDMzNzE2MDAxKSg0MjE4NjAwNCkoOTg2NzYwMDEpKDUzODA2MDAyKSg2?=
 =?utf-8?B?Mjk2NjAwMikoNTA5ODYwMDIpKDU0MzE2MDAzKSg0NzQ0NjAwMykoNTAyMjYw?=
 =?utf-8?B?MDEpKDQ5ODY2MDAxKSg0Mzk2MDAxKSg5NTQxNjAwMSkoMjAwOTAwMSkoNzY0?=
 =?utf-8?B?ODIwMDEpKDU5NzY2MDAyKSg5OTM5NjAwMikoNjM2OTYwMDQpKDY1ODE2MDAy?=
 =?utf-8?B?KSg1NjgxNjAwNikoMjE3ODczMDAxKTtESVI6T1VUO1NGUDoxMTAyO1NDTDox?=
 =?utf-8?B?O1NSVlI6Qk4xQUZGTzExSFVCMDEwO0g6U0otSVRFWEVER0UwMi5hbHRlcmEu?=
 =?utf-8?B?cHJpdi5hbHRlcmEuY29tO0ZQUjo3RkU2RUVCMi5BNDAwNUNDMS43MUU0QUZD?=
 =?utf-8?B?My5EOEUxRUVCNS4yMDE0RDtNTFY6c2Z2O1BUUjpJbmZvRG9tYWluTm9uZXhp?=
 =?utf-8?Q?stent;MX:1;A:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 017589626D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 18:22 +0200, Borislav Petkov wrote:
> On Tue, Apr 08, 2014 at 05:10:54PM +0100, Mark Rutland wrote:
> > Typically the bindings would go with the driver via the appropriate
> > subsystem maintainer. That way we don't get bindings without drivers
> > or vice-versa if there's a problem part-way, and we don't end up with
> > every other driver going via a dt tree.
> 
> Ok, I can pick them up then, once review is done.
> 
> @Thor, please CC linux-edac on the whole patchset for your next
> submission.

OK. Sorry. I'll add that on V2. Thanks for the gentle pointers.
> 
> Thanks.
> 

