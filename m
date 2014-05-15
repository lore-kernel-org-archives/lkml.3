Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaEOTZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:25:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42805 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaEOTZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:25:08 -0400
Message-ID: <5375148E.6040905@wwwdotorg.org>
Date: Thu, 15 May 2014 13:25:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [RFC PATCH 08/10] ARM: tegra124: Bind CAR to syscon device
References: <1400113986-339-1-git-send-email-abrestic@chromium.org> <1400113986-339-9-git-send-email-abrestic@chromium.org>
In-Reply-To: <1400113986-339-9-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 06:33 PM, Andrew Bresticker wrote:
> The XUSB PHY driver will be accessing the CAR registers through the
> syscon interface.

I very strongly don't want to use the syscon concept on Tegra. Instead,
I want only the CAR driver touching the CAR registers. If other drivers
need some CAR registers manipulated, that should happen by that other
driver calling some explicit semantic API in the CAR driver to do so.
Take a look at how the Tegra SMMU and Tegra AHB driver communicate for
an example.
