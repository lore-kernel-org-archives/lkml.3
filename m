Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935591Ab3DHScg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:32:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40630 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3DHSce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:32:34 -0400
Message-ID: <51630D3D.2040709@wwwdotorg.org>
Date: Mon, 08 Apr 2013 12:32:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: linux@arm.linux.org.uk, thierry.reding@avionic-design.de,
        ldewangan@nvidia.com, bhelgaas@google.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH 3/3] ARM: dts: tegra: Add PCIe entry for cardhu
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com> <1365435688-4179-3-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1365435688-4179-3-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 09:41 AM, Jay Agarwal wrote:
> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> 
> - Add PCIe node entry for cardhu
> - Enable only root port 2
> - Initialize regulators required for tegra30

Initialize isn't correct; this change makes no changes to any regulator;
it simply includes the required regulator properties in the new node.

I think you'd want to re-write this patch description as:

Enable the PCIe controller on Cardhu. Only port 2 is connected on this
board. It is connected to the Ethernet controller in the dock.

> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi

> +	pcie-controller {
...
>  	serial@70006000 {

It lookos like this node is added in the wrong place. Nodes should be
sorted based on reg property, and judging by the reg property for this
node in tegra30.dtsi in Thierry's branch, this should be the first node
in the Cardhu file.
