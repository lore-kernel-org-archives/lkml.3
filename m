Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3J3R7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:59:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43664 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686Ab3J3R7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:59:06 -0400
Date: Wed, 30 Oct 2013 10:58:53 -0700
From: Mark Rutland <mark.rutland@arm.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v2] ARC: Add perf support for ARC700 cores
Message-ID: <20131030175853.GB2815@kartoffel>
References: <1383144336-20802-1-git-send-email-mjonker@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1383144336-20802-1-git-send-email-mjonker@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 02:45:36PM +0000, Mischa Jonker wrote:
> This adds basic perf support for ARC700 cores. Most PERF_COUNT_HW* events
> are supported now.
> 
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> v2:
>         updated comments to kernel coding standards
>         renamed devicetree binding to snps,arc700-pmu
>         added devicetree binding doc
> 
>  Documentation/devicetree/bindings/arc/pmu.txt |   15 ++
>  arch/arc/boot/dts/angel4.dts                  |    4 +
>  arch/arc/include/asm/perf_event.h             |  204 +++++++++++++++-
>  arch/arc/kernel/Makefile                      |    1 +
>  arch/arc/kernel/perf_event.c                  |  322 +++++++++++++++++++++++++
>  5 files changed, 545 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/arc/pmu.txt
>  create mode 100644 arch/arc/kernel/perf_event.c

As a general note, for our own selfish reasons the device tree maintainers
would prefer that binding document changes were in a separate patch from any
code (though the whole series can be Cc'd to devicetree@vger.kernel.org, it's
oftern useful context). It makes it far easier to find the information relevant
to us, manage review and so on.

> 
> diff --git a/Documentation/devicetree/bindings/arc/pmu.txt b/Documentation/devicetree/bindings/arc/pmu.txt
> new file mode 100644
> index 0000000..d252d3b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arc/pmu.txt
> @@ -0,0 +1,15 @@
> +* ARC Performance Monitor Unit
> +
> +The ARC 700 can be configured with a pipeline performance monitor for counting
> +CPU and cache events like cache misses and hits.
> +
> +Required properties:
> +
> +- compatible : should be
> +       "snps,arc700-pmu"

s/should be/should contain/ -- there might be a future variant that's
compatible with the software-visible interface.

Is that ARC 700 a family or a specific implementation? If it's a family it may
make sense to define the strings you expect for particular implementations,
while still expecting "snps,arc700-pmu" to be in the compatible string list.

Are there any interrupts? Most PMUs I've seen have an interrupt for
overflow/saturation.

> +
> +Example:
> +
> +pmu {
> +        compatible = "snps,arc700-pmu";
> +};

Regardless, given it's so simple and can be extended easily in future, this
looks fine to me. With the minor change to the compatible description:

Acked-by Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
