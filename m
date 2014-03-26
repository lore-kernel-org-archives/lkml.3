Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaCZPK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:10:59 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:47340 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCZPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:10:57 -0400
X-AuditID: cbfec372-b7fa96d000006a7b-c3-5332edffe64b
Date: Wed, 26 Mar 2014 12:10:47 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>, Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>, Tony <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        linux-edac@vger.kernel.org, x86@kernel.org
Subject: Re: RFC: APEI hardware reduced profile
Message-id: <20140326121047.65176d7e@samsung.com>
In-reply-to: <6220935.TPfvPdvLIs@vostro.rjw.lan>
References: <5332C32A.5070301@linaro.org> <6220935.TPfvPdvLIs@vostro.rjw.lan>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/hEN3/b42CDW5uULT4vOEfm8XEfk2L
	nQ/fslmcunOAyWL5vn5GiwunGpgsLu+aw2Zx5vQlVotFO+4yWby5cI/F4seGx6wO3B7fW/tY
	PBbvecnksWlVJ5vHnWt72Dxu/3vM7LHlajuLx+bT1R6fN8kFcERx2aSk5mSWpRbp2yVwZfx8
	/oi54Ahfxebr71kbGM9ydzFyckgImEjMOHuXEcIWk7hwbz0biC0ksIRR4tBK3i5GLiC7h0mi
	5XUrC0iCRUBV4vffm+wgNpuAkcSrxhZWEFtEQFtibs8pZpAGZoFGZonXm88ATeLgEBbQl/h8
	EKyXV8BQYnfHS7Awp4CBxJSt+RC7fCXWLO5ih7jBSeLV68lMEOWCEj8m3wNrZRbQkti8rYkV
	wpaX2LzmLfMERoFZSMpmISmbhaRsASPzKkbR0uLkguKk9FxDveLE3OLSvHS95PzcTYyQKCna
	wfhsg9UhRgEORiUe3p33jYKFWBPLiitzDzFKcDArifDqPgMK8aYkVlalFuXHF5XmpBYfYmTi
	4JRqYPRbwtMRv9q91MzhhEzZJFPjDb1xYmHzf7d13pC+o93HM7GpncW+Wt1cm3fL9C27zF57
	zI/QWerUIa7+jnn7yYK06Z9m2RhmrbOt/dbvEfe+MfDPZPvbexrq5LQ/3T1pE74wc033xAMH
	P0dLeeaYqq+IfpQW8ixluuXB2Tt7Nkz19lY43fPOQImlOCPRUIu5qDgRAHq75elwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 26 Mar 2014 15:55:07 +0100
"Rafael J. Wysocki" <rjw@rjwysocki.net> escreveu:

> On Wednesday, March 26, 2014 01:08:10 PM Tomasz Nowicki wrote:
> > Hi,
> 
> Hi,
> 
> This is a question for Tony, Boris and Mauro (CCed now).
> 
> > Currently APEI depends on x86 architecture. It is because of many x86 
> > specific features like "IA-32 Architecture Corrected Machine Check
> > " error source or NMI hardware error notification. However, many other 
> > features like "PCI Express Device AER Structure" or GHES via external 
> > interrupt can be still used perfectly by other architectures. So my idea 
> > is to move x86 dependency away form Kconfig to APEI areas where it 
> > really applies to.
> > 
> > I have started refactoring ghes.c driver in that direction. And here 
> > comes my confusion, how should we treat x86 related parts, as fixed 
> > profile? (which means we could use ACPI_REDUCED_HARDWARE or 
> > CONFIG_ACPI_REDUCED_HARDWARE_ONLY define). I would like to ask for your 
> > opinion.

That's a good question, and probably depends on how are you mapping the
ACPI changes. For example, are you moving acpi out of /arch?

As I answered to a similar questioning, IMHO, the better would be to 
have the hardware error report mechanisms on /drivers/ras, and have 
there some Kconfig items that would depend on X86 to enable certain
drivers.

Also, I don't like to have something like ACPI_REDUCED_foo. IMHO, the
better would be to do the reverse: to have Kconfig symbols enabling the
extra X86-specific functionality, and have them mapped into separate
files/drivers, with proper KConfig names, like ACPI_X86 or ACPI_X86_NMI.

Yet, it would be better if you could be a little more specific about
what are your plans and what are the common/not-common features that
you're mapping.

Regards,
Mauro
