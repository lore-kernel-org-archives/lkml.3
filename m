Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaJ0QwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:52:09 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33415 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaJ0QwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:52:05 -0400
MIME-Version: 1.0
In-Reply-To: <1413244255-3880-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1413244255-3880-1-git-send-email-soren.brinkmann@xilinx.com>
Date: Mon, 27 Oct 2014 17:52:04 +0100
Message-ID: <CACRpkdYh3bZLodeNYubu_WQ-O=5My0Jt=b3g2GT3Mvy2XZMrLg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: lib-sysfs: Add 'wakeup' attribute
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 1:50 AM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> marking/unmarking a GPIO as wake IRQ.
> The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> is associated with that GPIO and the irqchip implements set_wake().
> Writing 'enabled' to that file will enable wake for that GPIO, while
> writing 'disabled' will disable wake.
> Reading that file will return either 'disabled' or 'enabled' depening on
> the currently set flag for the GPIO's IRQ.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> v2:
>  - fix error path to unlock mutex before return

As you're adding an ABI, you should be patching
Documentation/ABI/testing/sysfs-gpio and
Documentation/gpio/sysfs.txt in this patch.

While I *HATE* the idea of adding IRQ support to userspace
for GPIOs, this "just" adds the wakeup capacity, so I guess I'm
OK with it.

Provided you add it to the ABI doc...

Yours,
Linus Walleij
