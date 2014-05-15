Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaEOUjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:39:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36467 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbaEOUjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:39:13 -0400
Message-ID: <537525EB.9090704@wwwdotorg.org>
Date: Thu, 15 May 2014 14:39:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
CC: Mark Rutland <mark.rutland@arm.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [RFC PATCH 05/10] ARM: tegra: Export function to read USB calibration
 data
References: <1400113986-339-1-git-send-email-abrestic@chromium.org> <1400113986-339-6-git-send-email-abrestic@chromium.org>
In-Reply-To: <1400113986-339-6-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 06:33 PM, Andrew Bresticker wrote:
> Board-specific USB configuration data is stored in FUSE_SKU_CALIB_0.
> Export a function to read it so the PHY can be properly configured.

This patch seems conceptually fine to me. Presumably once Peter's fuse
driver is fleshed out, it can expose the exact same semantic interface
to drivers.

I suppose one could argue that we should create/use an explicit fuse
subsystem with a standard API that drivers can call into, rather than a
custom API. We can get the appropriate handle to use for that API from a
phandle (plus fuse IDs?) in a DT property (in the XHCI device node,
pointing at the fuse device node) much like any other cross-device
resource reference. I'm not too bothered whether the code actually does
that in the first instance, although we should make sure we add that DT
property (containing all required fuse ID information) so that the code
/can/ work that way if we want it to in the future.
