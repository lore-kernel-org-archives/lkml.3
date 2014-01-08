Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaAHShJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:37:09 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35642 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaAHShF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:37:05 -0500
MIME-Version: 1.0
In-Reply-To: <20131210193947.GU5429@obsidianresearch.com>
References: <20131210193947.GU5429@obsidianresearch.com>
Date: Wed, 8 Jan 2014 12:37:03 -0600
Message-ID: <CAL_JsqLpWSXd44ErAs=+xYS8ESaBSY6EJEneZFYqtbpfyM4iPQ@mail.gmail.com>
Subject: Re: [PATCH] dt: Document a compatible entry for MDIO ethernet Phys
From: Rob Herring <robherring2@gmail.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 1:39 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> This describes a compatible entry of the form:
>   ethernet-phy-idAAAA,BBBB
> Which is modelled after the PCI structured compatible entry
> (pciVVVV,DDDD.SSSS.ssss.RR)
>
> If present the OF core will be able to use this information to
> directly create the correct phy without auto probing the bus.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  Documentation/devicetree/bindings/net/phy.txt | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> Patch to parse this compatible string to follow if this binding is
> acceptable.

One minor comment below, otherwise:

Acked-by: Rob Herring <robh@kernel.org>

> Please see
>
> http://www.spinics.net/lists/devicetree/msg13175.html
>
> For discussion and a conceptual parsing patch.
>
> diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
> index 7cd18fb..d70b535 100644
> --- a/Documentation/devicetree/bindings/net/phy.txt
> +++ b/Documentation/devicetree/bindings/net/phy.txt
> @@ -23,10 +23,18 @@ Optional Properties:
>    assume clause 22. The compatible list may also contain other
>    elements.
>
> +  If the phy's identifier is known then the list may contain an entry
> +  of the form: "ethernet-phy-idAAAA,BBBB" where

I think this should be a period rather than a comma as we are not
separating a vendor ID from product ID.

Rob
