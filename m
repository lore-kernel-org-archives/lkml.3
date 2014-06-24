Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaFXVFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:05:54 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:37712 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaFXVFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:05:51 -0400
MIME-Version: 1.0
In-Reply-To: <1403598315-1429-1-git-send-email-vgupta@synopsys.com>
References: <1403598315-1429-1-git-send-email-vgupta@synopsys.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 24 Jun 2014 16:05:30 -0500
Message-ID: <CAL_JsqJF-a3K+dUHpwgSLNrwZTHLp2uj44bZaNboVpTtc8a-RA@mail.gmail.com>
Subject: Re: [PATCH v2 REBASED 00/10] Generic earlyconsole for ARC UART Driver
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Francois.Bedard@synopsys.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 3:25 AM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> Hi,
>
> This is slightly modified repost of series posted last week
> http://www.spinics.net/lists/linux-serial/msg12884.html
>
> This series switches ARC UART from custom earlyprintk support to generic
> earlycon (many thanks to Rob for doing that). And also build on Grant's recent
> work for using DT stdout-path as default console.
>
> The motivation is to get rid of the early platform code, which in turn
> would help consolidate the init code across several ARC platforms.
>
> First 3 patches are general cleanup/refactoring, not necesarily related to
> earlycon.

Other than my comment on patch 6:

Reviewed-by: Rob Herring <robh@kernel.org>

>
> v2 <- v1
> --------
> * Rebased on linux-next: 20140623
> * Patch 9 split into 9 and 10 for driver/platform changes
> * Patch 10 also uses the DT stdout-path so no need for console=
>
>
> Thx,
> -Vineet
>
>
> Vineet Gupta (10):
>   serial/arc: use uart_console_write() helper
>   serial/arc: Refactor by referencing to uart_port where possible
>   serial/arc: Remove the workaround for legacy ISS
>   serial/arc: Use generic earlycon infrastructure
>   serial/arc: remove earlyprintk support and switch to earlycon
>   serial/arc: remove last remanants of platform data
>   serial/arc: inline the probe helper
>   ARC: [arcfpga] RIP early uart platform device stuff
>   serial/arc: Enable DT based earlycon
>   ARC: [arcfpga] stdout-path now suffices for earlycon/console
>
>  arch/arc/boot/dts/angel4.dts     |   3 +-
>  arch/arc/plat-arcfpga/Kconfig    |   7 -
>  arch/arc/plat-arcfpga/platform.c |  97 +-----------
>  drivers/tty/serial/Kconfig       |   1 +
>  drivers/tty/serial/arc_uart.c    | 329 ++++++++++++++-------------------------
>  5 files changed, 123 insertions(+), 314 deletions(-)
>
> --
> 1.8.3.2
>
