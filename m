Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaA0P4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:56:15 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:61645 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaA0P4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:56:14 -0500
MIME-Version: 1.0
In-Reply-To: <1390823503-24087-4-git-send-email-alchark@gmail.com>
References: <1385227995-3956-1-git-send-email-alchark@gmail.com>
	<1390823503-24087-1-git-send-email-alchark@gmail.com>
	<1390823503-24087-4-git-send-email-alchark@gmail.com>
Date: Mon, 27 Jan 2014 09:56:12 -0600
Message-ID: <CAL_JsqLi0QKeeUkGMKmYZ1ki02mzk=L1gDxTJyXFGiOe_aHiVw@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: via-rhine: add OF bus binding
From: Rob Herring <robherring2@gmail.com>
To: Alexey Charkov <alchark@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, Tony Prisk <linux@prisktech.co.nz>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        rl@hellgate.ch,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 5:51 AM, Alexey Charkov <alchark@gmail.com> wrote:
> This should make the driver usable with VIA/WonderMedia ARM-based
> Systems-on-Chip integrated Rhine III adapters. Note that these
> are always in MMIO mode, and don't have any known EEPROM.
>
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> Signed-off-by: Roger Luethi <rl@hellgate.ch>
> ---
>  .../devicetree/bindings/net/via-rhine.txt          |  18 ++
>  drivers/net/ethernet/via/Kconfig                   |   2 +-
>  drivers/net/ethernet/via/via-rhine.c               | 293 +++++++++++++--------
>  3 files changed, 200 insertions(+), 113 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/via-rhine.txt
>
> diff --git a/Documentation/devicetree/bindings/net/via-rhine.txt b/Documentation/devicetree/bindings/net/via-rhine.txt
> new file mode 100644
> index 0000000..684dd3a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/via-rhine.txt
> @@ -0,0 +1,18 @@
> +* VIA Rhine 10/100 Network Controller
> +
> +Required properties:
> +- compatible : Should be "via,rhine"

This should be more specific rather than...

> +- reg : Address and length of the io space
> +- interrupts : Should contain the controller interrupt line
> +- rhine,revision : Rhine core revision, used to inform the
> +       driver of quirks and capabilities to expect from
> +       the device. Mimics the respective PCI attribute.

having this property. The OF match table can then have the quirks set
based on compatible strings.

Rob
