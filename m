Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaBHGfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 01:35:21 -0500
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:36925 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbaBHGfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 01:35:20 -0500
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Feb 2014 01:35:19 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=DAc5V9XIXz9DbUwu5WcMy++gZQkHCpksHTNRCrOAgDR4TlPbRZSpubHkI5NQA4n+;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Sat, 8 Feb 2014 01:22:25 -0500
From: Bill Fink <billfink@mindspring.com>
To: Marek Belisko <marek@goldelico.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        grant.likely@linaro.org, neilb@suse.de, hns@goldelico.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: rfkill-regulator: Add devicetree support.
Message-Id: <20140208012225.d7a311c7.billfink@mindspring.com>
In-Reply-To: <1391802529-29861-1-git-send-email-marek@goldelico.com>
References: <1391802529-29861-1-git-send-email-marek@goldelico.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4df68acaa64afcddb27586aa0eefb35c45350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.179.3.200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Feb 2014, Marek Belisko wrote:

> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
> Based on Neil's patch and extend for documentation and bindings include.
> 
>  .../bindings/net/rfkill/rfkill-relugator.txt       | 28 ++++++++++++++++

                                  ^^^^^^^^^
                                  Typo in file name.

					-Bill



>  include/dt-bindings/net/rfkill-regulator.h         | 23 +++++++++++++
>  net/rfkill/rfkill-regulator.c                      | 38 ++++++++++++++++++++++
>  3 files changed, 89 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/rfkill/rfkill-relugator.txt
>  create mode 100644 include/dt-bindings/net/rfkill-regulator.h
> 
> diff --git a/Documentation/devicetree/bindings/net/rfkill/rfkill-relugator.txt b/Documentation/devicetree/bindings/net/rfkill/rfkill-relugator.txt
> new file mode 100644
> index 0000000..cdb7dd7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/rfkill/rfkill-relugator.txt
> @@ -0,0 +1,28 @@
> +Regulator consumer for rfkill devices
> +
> +Required properties:
> +- compatible   : Must be "rfkill-regulator".
> +- label  : Name of rfkill device.
> +- type  : Type of rfkill device.
> +
> +Possible values (defined in include/dt-bindings/net/rfkill-regulator.h):
> +	RFKILL_TYPE_ALL
> +	RFKILL_TYPE_WLAN
> +	RFKILL_TYPE_BLUETOOTH
> +	RFKILL_TYPE_UWB
> +	RFKILL_TYPE_WIMAX
> +	RFKILL_TYPE_WWAN
> +	RFKILL_TYPE_GPS
> +	RFKILL_TYPE_FM
> +	RFKILL_TYPE_NFC
> +
> +- vrfkill-supply - regulator device.
> +
> +Example:
> +	gps-rfkill {
> +		compatible = "rfkill-regulator";
> +		label = "GPS";
> +		type = <RFKILL_TYPE_GPS>;
> +		vrfkill-supply = <&reg>;
> +	};
> +
