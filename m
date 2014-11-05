Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaKEVo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:44:26 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:61565 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaKEVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:44:25 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:797a:ae27:eb4f:f22]
In-Reply-To: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Wed, 5 Nov 2014 13:44:24 -0800
Message-ID: <CAOesGMheJzkQ9jEmDx9+hpjk0Scbnv_JiK1yH+7eoxY4PYUS4A@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
From: Olof Johansson <olof@lixom.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



On Mon, Nov 3, 2014 at 3:01 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Hi,
>
> This is second version of the patch series adding pinctrl/GPIO support
> for Intel Braswell and Cherrryview. The previous version can be found here:
>
> https://lkml.org/lkml/2014/10/27/118
>
> I've dropped patches [2/4] and [3/4] as they are already applied to the
> pinctrl tree.
>
> Changes to the previous version:
>
> [1/2] - Removed unnecessary cast and added Rafael's ACK.
>
> [2/2] - Use Ohms instead of kOhms in pin configuration.
>       - Change chv_config_set_pull() to be not so convoluted.
>       - Remove locking when we just read single register. This is not needed.
>       - Use BIT() instead of (1 << something)
>
> Mika Westerberg (2):
>   gpio / ACPI: Add knowledge about pin controllers to acpi_get_gpiod()
>   pinctrl: Add Intel Cherryview/Braswell pin controller support


Pinctrl setup has traditionally always been done by firmware on x86,
and some ARM platforms are again moving back to that state (since
reconfiguring pinctrl in the kernel is in some cases not safe).

What's the purpose of exposing this to the kernel on x86 now? I can
see the need to expose GPIO, but not pinctrl? Having the pin control
hidden away in firmware has been one of the benefits on x86, and
you're now undoing it... :)



-Olof
