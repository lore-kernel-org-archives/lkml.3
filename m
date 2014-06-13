Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaFMB1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 21:27:08 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:46738 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaFMB1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 21:27:05 -0400
MIME-Version: 1.0
In-Reply-To: <1402569099-9900-10-git-send-email-vgupta@synopsys.com>
References: <1402569099-9900-1-git-send-email-vgupta@synopsys.com> <1402569099-9900-10-git-send-email-vgupta@synopsys.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 12 Jun 2014 20:26:44 -0500
Message-ID: <CAL_Jsq+wf-nwzw_sYk4FiZxRr2advvjkd7i32arqVAFptDeVGA@mail.gmail.com>
Subject: Re: [PATCH 9/9] serial/arc: Add DT based earlycon support
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
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

On Thu, Jun 12, 2014 at 5:31 AM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---

Nice series!

>  arch/arc/boot/dts/angel4.dts  | 3 ++-
>  drivers/tty/serial/arc_uart.c | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arc/boot/dts/angel4.dts b/arch/arc/boot/dts/angel4.dts
> index 6b57475967a6..e9fc270d1e0b 100644
> --- a/arch/arc/boot/dts/angel4.dts
> +++ b/arch/arc/boot/dts/angel4.dts
> @@ -17,7 +17,8 @@
>         interrupt-parent = <&intc>;
>
>         chosen {
> -               bootargs = "earlycon=arc_uart,mmio32,0xc0fc1000,115200n8 console=ttyARC0,115200n8";
> +               bootargs = "earlycon console=ttyARC0,115200n8";
> +               stdout-path = &arcuart0;

Just FYI, Grant has a series to pickup the normal console from
stdout-path which would mean you can remove console param as well.
I've kicked him to respin it.

Rob

>         };
>
>         aliases {
> diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
> index 435de4f2af3b..d9900cb3e7b6 100644
> --- a/drivers/tty/serial/arc_uart.c
> +++ b/drivers/tty/serial/arc_uart.c
> @@ -579,6 +579,7 @@ static int __init arc_early_console_setup(struct earlycon_device *dev,
>         return 0;
>  }
>  EARLYCON_DECLARE(arc_uart, arc_early_console_setup);
> +OF_EARLYCON_DECLARE(arc_uart, "snps,arc-uart", arc_early_console_setup);
>
>  #endif /* CONFIG_SERIAL_ARC_CONSOLE */
>
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
