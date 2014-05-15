Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaEOUWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:22:47 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:52976 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaEOUWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:22:44 -0400
MIME-Version: 1.0
In-Reply-To: <5375148E.6040905@wwwdotorg.org>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
	<1400113986-339-9-git-send-email-abrestic@chromium.org>
	<5375148E.6040905@wwwdotorg.org>
Date: Thu, 15 May 2014 13:22:43 -0700
X-Google-Sender-Auth: IEmypcZ48cM9-Znr3EpfzfHPWFo
Message-ID: <CAL1qeaEKJ9F4cG-1N6fCMO0w1xR0S_sMnziHx4xhSj=NyQGWuA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/10] ARM: tegra124: Bind CAR to syscon device
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-usb@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 12:25 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/14/2014 06:33 PM, Andrew Bresticker wrote:
>> The XUSB PHY driver will be accessing the CAR registers through the
>> syscon interface.
>
> I very strongly don't want to use the syscon concept on Tegra. Instead,
> I want only the CAR driver touching the CAR registers. If other drivers
> need some CAR registers manipulated, that should happen by that other
> driver calling some explicit semantic API in the CAR driver to do so.
> Take a look at how the Tegra SMMU and Tegra AHB driver communicate for
> an example.

Understood.  I'll fix that up for the next spin.
