Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965776Ab3E2SiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:38:24 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53984 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab3E2SiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:38:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: James Hogan <james.hogan@imgtec.com>,
        <linux-arm-kernel@lists.infradead.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1368198127-1295-1-git-send-email-james.hogan@imgtec.com>
Cc: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        James Hogan <james.hogan@imgtec.com>
References: <1368198127-1295-1-git-send-email-james.hogan@imgtec.com>
Message-ID: <20130529183811.6058.78627@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC 0/2] clk: add metag specific gate/mux clocks
Date: Wed, 29 May 2013 11:38:11 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Hogan (2013-05-10 08:02:02)
> This adds a metag architecture specific clk-gate and clk-mux which
> extends the generic ones to use global lock2 to protect the register
> fields. It is common with metag to have an RTOS running on a different
> thread or core with access to different bits in the same register (which
> contain clock gate/switch bits for other clocks). Access to such
> registers must be serialised with a global lock such as the one provided
> by the metag architecture port in <asm/global_lock.h>
> 
> RFC because despite extending the generic clocks there's still a bit of
> duplicated code necessary. One alternative is to add special cases to
> the generic clock components for when a global or callback function
> based lock is desired instead of a spinlock, but I wasn't sure if that
> sort of hack would really be appreciated in the generic drivers.
> 
> Comments?
> 

The general approach looks OK, but you've kind of created generic
mux-clock and gate-clock bindings in a metag-specific driver.  I would
prefer to have those functions exist in the generic drivers and your
driver re-use those.  I'll be posting bindings for those clocks by the
end of the week (they're on my github repo now for the curious).

Wrapping the generic clock types is an OK approach and is done by
several other drivers, so there is no problem there.

Regards,
Mike

> James Hogan (2):
>   clk: metag/clk-gate: add metag specific clock gate
>   clk: metag/clk-mux: add metag specific clk-mux
> 
>  .../bindings/clock/img,meta-gate-clock.txt         |  28 +++
>  .../bindings/clock/img,meta-mux-clock.txt          |  33 ++++
>  drivers/clk/Makefile                               |   1 +
>  drivers/clk/metag/Makefile                         |   3 +
>  drivers/clk/metag/clk-gate.c                       | 179 +++++++++++++++++
>  drivers/clk/metag/clk-mux.c                        | 211 +++++++++++++++++++++
>  6 files changed, 455 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/img,meta-gate-clock.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/img,meta-mux-clock.txt
>  create mode 100644 drivers/clk/metag/Makefile
>  create mode 100644 drivers/clk/metag/clk-gate.c
>  create mode 100644 drivers/clk/metag/clk-mux.c
> 
> -- 
> 1.8.1.2
