Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaKGOyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:54:33 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:60730 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbaKGOyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:54:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: linaro-acpi@lists.linaro.org, catalin.marinas@arm.com, will.deacon@arm.com,
        bhelgaas@google.com, Liviu.Dudau@arm.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rjw@rjwysocki.net,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-acpi] [RFC PATCH 3/4] arm64, acpi, pci: Add arch specific functions for mmconfig driver.
Date: Fri, 07 Nov 2014 15:54:09 +0100
Message-ID: <2483899.fnsktEmYFO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <545CD9A4.3080900@linaro.org>
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org> <16660879.6KxQndPqBW@wuerfel> <545CD9A4.3080900@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:s3EKadAGtjxe5MzocKW8h1/iIOPogkF09I2oXimBmnz
 2mnwArwFnGuXRbayK8IP0q+6uIgDcU95uj+Ruzv+p4XJutVV8l
 SpW+MOQZfWuvPVFXIk6x0DnjJn6u0IGAamAtIEoqGpe6ZTpOOh
 YELMp986g9ZyhPnJeKV4goEoCUSxf/UAih83AKz5Z73ya/0ISo
 nCpPlQP1bha6cwsZddb5F10ydc9iQ/28A449DkbnXQsFJYODHP
 LIM4LAvb/sq+l3R19zusJRou9hmsyt882htQNUKR15MI8tcDnJ
 kOLkkRkWw4QzJ+AtvNcTx79pEFqiyTk17hd/+KBrLGcEEV3phk
 S3vTXrpKkYHWDVRyd+0Y=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 15:39:32 Tomasz Nowicki wrote:
> On 07.11.2014 15:12, Arnd Bergmann wrote:
> > On Friday 07 November 2014 14:27:55 Tomasz Nowicki wrote:
> >> These calls allow to map/unmap PCI config space ranges (which are specified in
> >> MMCFG ACPI table).
> >>
> >> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> >>
> >
> > Nothing in this patch looks arm64 specific, and most of it looks like a
> > copy of the x86 code.
> 
> Yes, most of the logic was borrowed from mmconfig_64.c file, 
> mmconfig_32.c looks differently, though. It is not simple to merge them 
> both. IMO, we have two choices:
> 1. Refactor and move mmconfig_64.c out of x86 to e.g. drivers/acpi/ and 
> let it be default.
> 2. Stay with solution presented in this patch.
> 3. Thoughts ?

If the code is generic, it should be shared with as many architectures as
possible. Moving the x86-64 implementation to drivers/acpi/ would immediately
let you share it with two out of the four architectures (x86-64 and arm64,
but not x86-32 and ia64) as well as any potential other architectures that
might implement ACPI in the future.

	Arnd
