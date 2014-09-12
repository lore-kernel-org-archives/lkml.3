Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaILB4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 21:56:34 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:58580 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaILB4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 21:56:33 -0400
MIME-Version: 1.0
In-Reply-To: <1410473644-19103-1-git-send-email-sboyd@codeaurora.org>
References: <1410473644-19103-1-git-send-email-sboyd@codeaurora.org>
From: Rob Herring <robh@kernel.org>
Date: Thu, 11 Sep 2014 20:56:12 -0500
X-Google-Sender-Auth: g6mKloChg4Rf1gsUBp7R4Lovo8c
Message-ID: <CAL_JsqLtx9+P1-O+gVRRhpjntHuNQZp4ASV8ScBhZB7gWDsGFw@mail.gmail.com>
Subject: Re: [PATCH/RESEND] tty: serial: msm: Add DT based earlycon support
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 5:14 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Add support for DT based early console on platforms with the msm
> serial hardware.
>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

One comment, but looks good to me.

Acked-by: Rob Herring <robh@kernel.org>

> +static int __init
> +msm_serial_early_console_setup(struct earlycon_device *device, const char *opt)
> +{
> +       if (!device->port.membase)
> +               return -ENODEV;
> +
> +       device->con->write = msm_serial_early_write;
> +       return 0;
> +}
> +OF_EARLYCON_DECLARE(msm_serial, "qcom,msm-uart",
> +                   msm_serial_early_console_setup);

Don't you want to support kernel command line as well? Then if you
can't change the DT or bootloader's command line, you can add it into
the kernel build with the appended command line. Don't forget to
document it in kernel-parameters.txt if you do.

Rob
