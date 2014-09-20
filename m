Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaITXqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 19:46:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37353 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaITXqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 19:46:09 -0400
Message-ID: <541E11BB.7070202@gmail.com>
Date: Sun, 21 Sep 2014 01:46:03 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/5] ARM: mvebu: armada-xp: Correct misnumbered PCIe port
 nodes
References: <1411236391-422-1-git-send-email-sebastian.hesselbarth@gmail.com> <1411236391-422-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1411236391-422-4-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2014 08:06 PM, Sebastian Hesselbarth wrote:
> Currently, Armada XP PCIe nodes are numbered pcie@<N>,0 with N just
> incrementing. To reflect port/lane relationship, rename the nodes
> to pcie@<port>,<lane>. While at it, add node aliases to each of pcie
> controller and port nodes and get rid of now redundant port/lane
> comments.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---

After thinking a while about the current numbering scheme, I have to
admit that it is correct. The @numbers represent assigned-address of
the pcie port and this what it is right now.

If there are no more comments, I'll resend the series without messing
with the numbering scheme.

Sebastian

> ---
>  arch/arm/boot/dts/armada-xp-axpwifiap.dts        | 11 ++++-------
>  arch/arm/boot/dts/armada-xp-db.dts               | 20 +++++++-------------
>  arch/arm/boot/dts/armada-xp-gp.dts               | 11 ++++-------
>  arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts  |  8 +++-----
>  arch/arm/boot/dts/armada-xp-matrix.dts           |  5 ++---
>  arch/arm/boot/dts/armada-xp-mv78230.dtsi         | 12 ++++++------
>  arch/arm/boot/dts/armada-xp-mv78260.dtsi         | 20 ++++++++++----------
>  arch/arm/boot/dts/armada-xp-mv78460.dtsi         | 22 +++++++++++-----------
>  arch/arm/boot/dts/armada-xp-netgear-rn2120.dts   | 11 ++++-------
>  arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  5 ++---
>  10 files changed, 53 insertions(+), 72 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/armada-xp-axpwifiap.dts b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
> index 0e53fad111de..1b2dd3a4000b 100644
> --- a/arch/arm/boot/dts/armada-xp-axpwifiap.dts
> +++ b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
> @@ -37,24 +37,21 @@
>  		ranges = <MBUS_ID(0xf0, 0x01) 0 0 0xf1000000 0x100000
>  			  MBUS_ID(0x01, 0x1d) 0 0 0xfff00000 0x100000>;
>  
> -		pcie-controller {
> +		pcie: pcie-controller {
>  			status = "okay";
>  
>  			/* First mini-PCIe port */
> -			pcie@1,0 {
> -				/* Port 0, Lane 0 */
> +			pcie00: pcie@0,0 {
>  				status = "okay";
>  			};
>  
>  			/* Second mini-PCIe port */
> -			pcie@2,0 {
> -				/* Port 0, Lane 1 */
> +			pcie01: pcie@0,1 {
>  				status = "okay";
>  			};
>  
>  			/* Renesas uPD720202 USB 3.0 controller */
> -			pcie@3,0 {
> -				/* Port 0, Lane 3 */
> +			pcie03: pcie@0,3 {
>  				status = "okay";
>  			};
>  		};
[...]

