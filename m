Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaG2QKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:10:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48303 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaG2QKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:10:54 -0400
Message-ID: <53D7C769.6080500@ti.com>
Date: Tue, 29 Jul 2014 11:10:17 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Dave Gerlach <d-gerlach@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Robert Tivy <rtivy@ti.com>
Subject: Re: [PATCH 1/2] remoteproc: use a flag to detect the presence of
 IOMMU
References: <1404836521-59637-1-git-send-email-s-anna@ti.com> <1404836521-59637-2-git-send-email-s-anna@ti.com> <CAK=Wgbawdik3ZB0Zbeaa7eXd7M+9ev9u713GcfOc4Gy0+O80Dg@mail.gmail.com>
In-Reply-To: <CAK=Wgbawdik3ZB0Zbeaa7eXd7M+9ev9u713GcfOc4Gy0+O80Dg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 07/29/2014 05:57 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Tue, Jul 8, 2014 at 7:22 PM, Suman Anna <s-anna@ti.com> wrote:
>> The remoteproc driver core currently relies on iommu_present() on
>> the bus the device is on, to perform MMU management. However, this
>> logic doesn't scale for multi-arch, especially for processors that
>> do not have an IOMMU.
> 
> Is there a specific hw/scenario where you need this? Can you please
> provide more details about it?

We are trying to add a remoteproc driver for a small Cortex M3 called
the WkupM3 used for suspend/resume management on TI AM335/AM437x SoCs.
This processor does not have an MMU. Same is the case with another
processor subsystem PRU-ICSS on AM335/AM437x. All these are platform
devices, and the current iommu_present check will not scale for the same
kernel image to support OMAP4/OMAP5 and AM335/AM437x.

This patch mainly addresses the existing comments in the code,
-	 * This works for simple cases, but will easily fail with
-	 * platforms that do have an IOMMU, but not for this specific
-	 * rproc.
-	 *
-	 * This will be easily solved by introducing hw capabilities
-	 * that will be set by the remoteproc driver.

> 
> Ideally we should add them to the commit log as well.
> 
>> The individual platform implementations are required to set this
>> flag appropriately. The default setting is to not have an MMU.
> 
> Let's explicitly set the default please so this would be clear for
> users reading the code.

OK, I can update the existing drivers to explicitly set this field.

> 
>> Cc: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> Sjur is no longer with STE, so no point in cc'ing his old email address.

Yeah, I wasn't aware until I got a bounced email.

> 
>> +       /*
>> +        * All existing OMAP IPU and DSP processors do have an MMU, and
>> +        * are expected to use MMU, so this statement suffices.
>> +        * XXX: Replace this logic if and when a need arises.
> 
> The last XXX comment is always true for any kernel code, so I'd drop it.

Sure.

regards
Suman
