Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbaAaWbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:31:36 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41902 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbaAaWbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:31:34 -0500
MIME-Version: 1.0
In-Reply-To: <1391205045-1751-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1391205045-1751-1-git-send-email-jgunthorpe@obsidianresearch.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 31 Jan 2014 14:30:53 -0800
Message-ID: <CAGVrzcYz6m203EwT6exr06mpTdFQDQ3hHwq+WBhLa7zXnAFGAw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt: Document a compatible entry for MDIO ethernet Phys
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-31 Jason Gunthorpe <jgunthorpe@obsidianresearch.com>:
> This describes a compatible entry of the form:
>   ethernet-phy-idAAAA,BBBB
> Which is modelled after the PCI structured compatible entry
> (pciVVVV,DDDD.SSSS.ssss.RR)
>
> If present the OF core will be able to use this information to
> directly create the correct phy without auto probing the bus.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Acked-by: Rob Herring <robh@kernel.org>

Looks good, thanks!

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  Documentation/devicetree/bindings/net/phy.txt | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> Cc: devicetree@vger.kernel.org
>
> diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
> index 7cd18fb..989122c 100644
> --- a/Documentation/devicetree/bindings/net/phy.txt
> +++ b/Documentation/devicetree/bindings/net/phy.txt
> @@ -23,10 +23,18 @@ Optional Properties:
>    assume clause 22. The compatible list may also contain other
>    elements.
>
> +  If the phy's identifier is known then the list may contain an entry
> +  of the form: "ethernet-phy-idAAAA.BBBB" where
> +     AAAA - The value of the 16 bit Phy Identifier 1 register as
> +            4 hex digits. This is the chip vendor OUI bits 3:18
> +     BBBB - The value of the 16 bit Phy Identifier 2 register as
> +            4 hex digits. This is the chip vendor OUI bits 19:24,
> +            followed by 10 bits of a vendor specific ID.
> +
>  Example:
>
>  ethernet-phy@0 {
> -       compatible = "ethernet-phy-ieee802.3-c22";
> +       compatible = "ethernet-phy-id0141.0e90", "ethernet-phy-ieee802.3-c22";
>         linux,phandle = <2452000>;
>         interrupt-parent = <40000>;
>         interrupts = <35 1>;
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Florian
