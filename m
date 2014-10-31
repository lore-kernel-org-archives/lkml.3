Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbaJaJtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:49:31 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:58867 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbaJaJt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <544ECFB4.7040704@linux.com>
References: <1414447799-1284-1-git-send-email-matthias.klein@linux.com>
	<544ECAB2.3060706@wwwdotorg.org>
	<544ECFB4.7040704@linux.com>
Date: Fri, 31 Oct 2014 10:49:28 +0100
Message-ID: <CACRpkdbhEBQfEpkK6-4GNyTQvvJ2qJ+RfXUULJNxvrbrpv1NAg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: bcm2835: Start GPIO numeration at zero
From: Linus Walleij <linus.walleij@linaro.org>
To: Matthias Klein <matthias.klein@linux.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        linux-rpi-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 12:05 AM, Matthias Klein
<matthias.klein@linux.com> wrote:
> Am 27.10.2014 um 23:44 schrieb Stephen Warren:

>> What's the motivation for this? The GPIO IDs should all come from DT,
>> which encodes everything as an ID relative to a particular controllers, and
>> hence the actual value of the base address should be irrelevant.
>
> - To be in sync with the GPIO numbers in the datasheet / documentation

We are moving away from global GPIO numbers because they are
an eternal pain. We would replace them with a local offset number
just as the second column in /proc/interrupts

Hm we should patch <debugfs/gpio> to show local offsets...

> - For userland applications which rely on these GPIO numbers

ARGH!!!

A much better idea is to add labels to your GPIOs so you can
identify them by name. Augment the driver with labeling capability
if need be, see e.g. commit 781f6d710d4482eab05cfaad50060a0ea8c0e4e0
"gpio: generic: Add label to platform data"

You just need to figure out how to do the same naming from the
device tree. Maybe some new binding is needed, others are
discussing how to do exporting of GPIOs from devicetree
anyway, see the mailing list.

Yours,
Linus Walleij
