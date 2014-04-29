Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbaD2W24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:28:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63603 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbaD2W2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:28:54 -0400
Date: Tue, 29 Apr 2014 15:27:57 -0700
From: Mark Rutland <mark.rutland@arm.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH v1] serial: uart: add hw flow control support
 configuration
Message-ID: <20140429222756.GA2382@flaeskesteg>
References: <1398792122-18592-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398792122-18592-1-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 29, 2014 at 06:22:02PM +0100, Murali Karicheri wrote:
> 8250 uart driver currently supports only software assisted hw flow
> control. The software assisted hw flow control maintains a hw_stopped
> flag in the tty structure to stop and start transmission and use modem
> status interrupt for the event to drive the handshake signals. This is
> not needed if hw has flow control capabilities. This patch adds a
> DT attribute for enabling hw flow control for a uart port. Also skip
> stop and start if this flag is present in flag field of the port
> structure.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Pawel Moll <pawel.moll@arm.com> 
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
> CC: Kumar Gala <galak@codeaurora.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Jiri Slaby <jslaby@suse.cz>
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  - Fixed brackets around port->flags & UPF_HARD_FLOW as per comments 
>  .../devicetree/bindings/serial/of-serial.txt       |    2 ++
>  drivers/tty/serial/8250/8250_core.c                |    6 ++++--
>  drivers/tty/serial/of_serial.c                     |    4 ++++
>  drivers/tty/serial/serial_core.c                   |   12 +++++++++---
>  4 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
> index 1928a3e..123de01 100644
> --- a/Documentation/devicetree/bindings/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
> @@ -37,6 +37,8 @@ Optional properties:
>  - auto-flow-control: one way to enable automatic flow control support. The
>    driver is allowed to detect support for the capability even without this
>    property.
> +- hw-flow-control: this enables pure hw flow control and no software
> +  intervention needed.

>From the wording of the commit message, I believe this would be better worded
something like:

- hw-flow-control: the hardware has flow control capability.

While the OS needs to know that flow control is present if it wishes to make
use of it, whether or not the OS does so is not a matter for the binding.

It might also be better worded as "has-hw-flow-control", which would make that
distinction clearer.

Otherwise this looks fine to me.

Thanks,
Mark.
