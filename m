Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaFLVSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:18:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56780 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaFLVSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:18:00 -0400
Message-ID: <539A1904.2000601@wwwdotorg.org>
Date: Thu, 12 Jun 2014 15:17:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alban Bedel <alban.bedel@avionic-design.de>,
        Rob Herring <robh+dt@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: tamonten: add the base board regulators
References: <1402585885-28247-1-git-send-email-alban.bedel@avionic-design.de>
In-Reply-To: <1402585885-28247-1-git-send-email-alban.bedel@avionic-design.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 09:11 AM, Alban Bedel wrote:
> Currently the Tamonten DTS define a fixed regulator for the 5V supply.
> However this regulator is in fact on the base board. Fix this by
> properly defining the regulators found on the base boards.

> diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dts/tegra20-medcom-wide.dts

> +	board_regulators {

The name "board_regulators" encodes both type ("regulators") and
identify ("board": the regulators on the board). DT node names are
suposed to contain type but not identity information.

The way this is done in other Tegra DTs is to have a regulators node in
both the board and module DT files, and use different ranges of reg
values for the board and module; e.g. 0..99 for module and 100.. for the
board or similar.

Other than that, this patch looks fine.
