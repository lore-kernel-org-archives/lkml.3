Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbaJXSDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:03:37 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42746 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbaJXSDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:03:36 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH] ARM: OMAP4+: PM: Program CPU logic power state
References: <1413923076-26063-1-git-send-email-nm@ti.com>
Date: Fri, 24 Oct 2014 11:03:31 -0700
In-Reply-To: <1413923076-26063-1-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Tue, 21 Oct 2014 15:24:36 -0500")
Message-ID: <7h61f98hvw.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> CPU logic power state is never programmed in either the initialization
> or the suspend/resume logic, instead, we depend on mpuss to program this
> properly. However, this leaves CPU logic power state indeterminate and
> most probably in reset configuration (If bootloader or other similar
> software have'nt monkeyed with the register). This can make powerstate=
> RET be either programmed for CSWR (logic=ret) or OSWR(logic = OFF) and
> in OSWR, there can be context loss when the code does not expect it.
>
> To prevent all these confusions, just support clearly ON, INA, CSWR,
> OFF which is the intent of the existing code by explicitly programming
> logic state.
>
> NOTE: since this is a hot path (using in cpuidle), the exit path just
> programs powerstate (logic state is immaterial when powerstate is ON).
>
> Without doing this, we end up with lockups when CPUs enter OSWR and
> multiple blocks loose context, when we expect them to hit CSWR.
>
> Signed-off-by: Nishanth Menon <nm@ti.com>

Acked-by: Kevin Hilman <khilman@linaro.org>
