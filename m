Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaAOL2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:28:42 -0500
Received: from 10.mo6.mail-out.ovh.net ([87.98.157.236]:59349 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751237AbaAOL2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:28:39 -0500
Date: Wed, 15 Jan 2014 12:23:52 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: nicolas.ferre@atmel.com, b.brezillon@overkiz.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 12/12] at91: dt: sam9261: Added DM9000 in the device
 tree
Message-ID: <20140115112352.GQ14627@ns203013.ovh.net>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
 <1389270709-32662-13-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389270709-32662-13-git-send-email-jjhiblot@traphandler.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 8140256327173450585
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:31 Thu 09 Jan     , Jean-Jacques Hiblot wrote:
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  arch/arm/boot/dts/at91sam9261ek.dts | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9261ek.dts b/arch/arm/boot/dts/at91sam9261ek.dts
> index e92cb8e..a3d9d5a 100644
> --- a/arch/arm/boot/dts/at91sam9261ek.dts
> +++ b/arch/arm/boot/dts/at91sam9261ek.dts
> @@ -76,6 +76,38 @@
>  		smc: smc@ffffec00 {
>  			status = "okay";
>  
> +			ebi_cs2@2,0 {
> +				status = "okay";
> +				smc,converter = "nanosec";
> +				smc,ncs_read_setup = <0>;
> +				smc,nrd_setup = <20>;
> +				smc,ncs_write_setup = <0>;
> +				smc,nwe_setup = <20>;
> +				smc,ncs_read_pulse = <80>;
> +				smc,nrd_pulse = <40>;
> +				smc,ncs_write_pulse = <80>;
> +				smc,nwe_pulse = <40>;
> +				smc,read_cycle = <160>;
> +				smc,write_cycle = <160>;
> +				smc,tdf_cycles = <10>;
> +				smc,tdf_optimized = <0>;
> +				smc,page_size = <0>;
> +				smc,byte_access_type = <1>;
> +				smc,bus_width = <1>;
> +				smc,nwait_mode = <0>;
> +				smc,read_mode = <1>;
> +				smc,write_mode = <1>;
> +
> +				ethernet@2,0 {
> +					compatible = "davicom,dm9000";
> +					reg = <0x0 0x2 0x4 0x2>;
> +					interrupt-parent = <&pioC>;
> +					interrupts = <11 IRQ_TYPE_EDGE_BOTH>;
use the new binding no interrupt-parent now
> +					local-mac-address = [00 00 de ad be ef];
drop the mac this is board specific
> +					davicom,no-eeprom;
> +				};
> +			};
> +
>  			ebi_cs3@3,0 {
>  				status = "okay";
>  				smc,ncs_read_setup = <0>;
> -- 
> 1.8.5.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list:wqa

> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
