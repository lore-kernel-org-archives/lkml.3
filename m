Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaIIKx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:53:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40559 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539AbaIIKx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:53:57 -0400
Date: Tue, 9 Sep 2014 11:53:10 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Ankit Jindal <ankit.jindal@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "patches@apm.com" <patches@apm.com>, Rob Herring <robh+dt@kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/5] dt-bindings: Add binding info for Xgene QMTM UIO
 driver
Message-ID: <20140909105310.GC27786@leverpostej>
References: <1410256619-3213-1-git-send-email-ankit.jindal@linaro.org>
 <1410256619-3213-5-git-send-email-ankit.jindal@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410256619-3213-5-git-send-email-ankit.jindal@linaro.org>
Thread-Topic: [PATCH 4/5] dt-bindings: Add binding info for Xgene QMTM UIO
 driver
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:56:58AM +0100, Ankit Jindal wrote:
> This patch adds device tree binding documentation for
> Xgene QMTM UIO driver.
> 
> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
> ---
>  .../devicetree/bindings/uio/uio_xgene_qmtm.txt     |   45 ++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
> 
> diff --git a/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
> new file mode 100644
> index 0000000..b71831b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
> @@ -0,0 +1,45 @@
> +APM X-Gene QMTM UIO nodes
> +
> +QMTM UIO nodes are defined for user space access to on-chip QMTM device
> +on APM X-Gene SOC using UIO framework.
> +

Userspace vs kernel space has precisely _nothing_ to do with a HW
description.

This doesn't describe at all what the device is (e.g. what does QMTM
stand for, what is it used for?).

NAK.

Please ensure you Cc the devicetree list (devicetree@vger.kernel.org) in
future.

> +Required properties:
> +- compatible: Should be "apm,xgene-qmtm-uio"

This should definitely not have "uio" in the name.

> +- reg: Address and length of the register set for the device. It contains the
> +  information of registers in the same order as described by reg-names.
> +- reg-names: Should contain the register set names
> +  - "csr": QMTM control and status register address space.
> +  - "fabric": QMTM memory mapped access to queue states.

These look ok, I guess.

> +  - "qpool": Memory location for creating QMTM queues. This could be some
> +    SRAM or reserved portion of RAM. It is expected that size and location
> +    of qpool memory will be configurable via bootloader.

I don't follow why this should be described in a reg entry. This is not
a property of the device; this is a separate resource being assigned to
the device.

Why can the kernel not allocate this dynamically?

If you need a specific fixed pool, use the reserved-memory bindings.

> +- clocks: Reference to the clock entry.

There is only one clock input to the IP block?

> +- num_queues: Number of queues under this QMTM device.

s/_/-/, property names should use '-' rather than '_'.

> +- devid: QMTM identification number for the system having multiple QMTM devices

What exactly is this used for? Why is the reg entry not sufficient?

> +Optional properties:
> +- status: Should be "ok" or "disabled" for enabled/disabled. Default is "ok".

This is so standard I don't see the point in documenting it.

Mark.
