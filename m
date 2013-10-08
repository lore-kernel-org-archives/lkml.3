Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3JHF6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:58:17 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47577 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab3JHF6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:58:10 -0400
MIME-Version: 1.0
In-Reply-To: <20131008143217.0611fba0c0d27d9c622759f3@ops.dti.ne.jp>
References: <20131008143040.52f36df8edb7ab63224d8433@ops.dti.ne.jp>
	<20131008143217.0611fba0c0d27d9c622759f3@ops.dti.ne.jp>
Date: Tue, 8 Oct 2013 14:58:08 +0900
Message-ID: <CANqRtoRZM=5FYG7+fq5c+TQEuHtJRmcGP1CmMq5kO5Ayvg=W6w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] clk: emev2: Add support for emev2 SMU clocks with DT
From: Magnus Damm <magnus.damm@gmail.com>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Mike Turquette <mturquette@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 2:32 PM,  <takasi-y@ops.dti.ne.jp> wrote:
> Device tree clock binding document for EMMA Mobile EV2 SMU,
> And Common clock framework based implementation of it.
> Following nodes are defined to describe clock tree.
> - renesas,emev2-smu
> - renesas,emev2-smu-clkdiv
> - renesas,emev2-smu-gclk
>
> These bindings are designed manually based on
>  19UH0037EJ1000_SMU : System Management Unit User's Manual
>
> So far, reparent is not implemented, and is fixed to index #0.
> Clock tree description is not included, and should be provided
> by device-tree.
>
> Signed-off-by: Takashi Yoshii <takasi-y@ops.dti.ne.jp>
> ---
>  .../devicetree/bindings/clock/emev2-clock.txt      |  98 +++++++++++++++++++
>  drivers/clk/Makefile                               |   1 +
>  drivers/clk/shmobile/Makefile                      |   3 +
>  drivers/clk/shmobile/clk-emev2.c                   | 104 +++++++++++++++++++++
>  4 files changed, 206 insertions(+)

Thanks for cleaning up the Makefile bits, Yoshii-san.

This patch and the bindings look fine to me from a SoC point of view.
Using these together with the topology information in emev2.dtsi makes
it possible for us to use CCF and multiplatform as expected on the
EMEV2 SoC.

Acked-by: Magnus Damm <damm@opensource.se>
