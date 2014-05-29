Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbaE2NpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:45:00 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60220 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbaE2No7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:44:59 -0400
MIME-Version: 1.0
In-Reply-To: <1401218804-77997-1-git-send-email-eric.ernst@linux.intel.com>
References: <1401218804-77997-1-git-send-email-eric.ernst@linux.intel.com>
Date: Thu, 29 May 2014 15:44:59 +0200
Message-ID: <CACRpkdaR0E_fnFZaX7zYmxtLjEuRKr_XW7B8HavpkkjArmy35A@mail.gmail.com>
Subject: Re: [PATCH 1/1] PINCTRL: Warn if direct IRQ GPIO set to output
From: Linus Walleij <linus.walleij@linaro.org>
To: eric.ernst@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Gross <mark.gross@intel.com>,
        "Holmberg, Hans" <hans.holmberg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 9:26 PM,  <eric.ernst@linux.intel.com> wrote:

> From: Eric Ernst <eric.ernst@linux.intel.com>
>
> For Baytrail, you should never set a GPIO set to direct_irq
> to output mode.  When direct_irq_en is set for a GPIO, it is
> tied directly to an APIC internally, and making the pad output
> does not make any sense. Assert a WARN() in the event this happens.
>
> Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>

Can I get some ACK from the author's of this driver on Eric's patch?

Eric, you *are* aware of what the gpio_lock_as_irq() and
gpio_unlock_as_irq() in the .irq_request_resources are doing
right? Is this patch just some extra safety measure?

Yours,
Linus Walleij
