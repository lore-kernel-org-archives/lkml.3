Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab3HOWDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:03:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54745 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3HOWC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:02:58 -0400
Message-ID: <520D500C.5070901@wwwdotorg.org>
Date: Thu, 15 Aug 2013 16:02:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Martin <Dave.Martin@arm.com>
CC: Alexandre Courbot <acourbot@nvidia.com>, gnurou@gmail.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org,
        Joseph Lo <josephl@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/5] ARM: add basic Trusted Foundations support
References: <1376360992-1508-1-git-send-email-acourbot@nvidia.com> <1376360992-1508-2-git-send-email-acourbot@nvidia.com> <20130815115227.GC2562@localhost.localdomain>
In-Reply-To: <20130815115227.GC2562@localhost.localdomain>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 05:52 AM, Dave Martin wrote:
> On Tue, Aug 13, 2013 at 11:29:48AM +0900, Alexandre Courbot wrote:
>> Trusted Foundations is a TrustZone-based secure monitor for ARM that
>> can be invoked  using a consistent smc-based API on all supported
>> platforms. This patch adds initial basic support for Trusted
>> Foundations using the ARM firmware API. Current features are limited
>> to the ability to boot secondary processors.

>> diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt

>> +Required properties:
>> +- compatible : "tl,trusted-foundations"
>> +- version : Must contain the version number string of the Trusted Foundation
>> +	firmware.
> 
> Are you sure there is no low-level way to probe vendor and version info?
> If there is, then the DT should describe nothing except the fact that
> the probe interface exists.
> 
> I also worry that two integrations on different SoCs might have the
> same version number, yet still be different due to vendor-specific
> features and options.

I would expect HW-specific compatible values also to be present in a DT.
For example, perhaps:

compatible = "tl,trusted-foundations-nvidia-shield",
"tl,trusted-foundations";

(nvidia vendor, shield board/implementation)

This would allow matching on the specific value
"tl,trusted-foundations-nvidia-shield" in the future if some quirking
was needed, but if this wasn't needed, drivers could just bind to the
generic "tl,trusted-foundations".

>> +- version : Must contain the version number string of the Trusted Foundation
>> +	firmware.
> 
> Are you sure there is no low-level way to probe vendor and version info?
> If there is, then the DT should describe nothing except the fact that
> the probe interface exists.
> 
> I also worry that two integrations on different SoCs might have the
> same version number, yet still be different due to vendor-specific
> features and options.

Talking of the version - if we do need to represent this in the DT, how
about 2 separate cells for major/minor version rather than encoding it
into a string? Then, no parsing would be required.
