Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaH2HQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:16:19 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:42311 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaH2HQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <1408533887-22727-4-git-send-email-daniel.baluta@intel.com>
References: <1408533887-22727-1-git-send-email-daniel.baluta@intel.com>
	<1408533887-22727-4-git-send-email-daniel.baluta@intel.com>
Date: Fri, 29 Aug 2014 09:16:17 +0200
Message-ID: <CACRpkdaZcpTXiNZNKFeQgESxtYqKC+gR-VYbxoORYrykGUWRVw@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: add support for the Diolan DLN-2 USB-GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Baluta <daniel.baluta@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "pratyush.anand@st.com" <pratyush.anand@st.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Alan Stern <stern@rowland.harvard.edu>, octavian.purdila@intel.com,
        matthew@mjdsystems.ca,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        laurentiu.palcu@intel.com, Jean Delvare <jdelvare@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, Simon Glass <sjg@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 1:24 PM, Daniel Baluta <daniel.baluta@intel.com> wrote:

> This patch adds GPIO and IRQ support for the Diolan DLN-2 GPIO module.
>
> Information about the USB protocol interface can be found in the
> Programmer's Reference Manual [1], see section 2.9 for the GPIO
> module commands and responses.
>
> [1] https://www.diolan.com/downloads/dln-api-manual.pdf
>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>

Major change required: rewrite this driver to not select IRQ_DOMAIN,
instead select GPIOLIB_IRQCHIP and use the shared infrastructure.
See other drivers that select GPIOLIB_IRQCHIP or grep the git
log to see how this works in practice.

You need to use some container_of() operations.

Yours,
Linus Walleij
