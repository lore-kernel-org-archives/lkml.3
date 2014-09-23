Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaIWKOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:14:00 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:63830 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaIWKN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:13:56 -0400
MIME-Version: 1.0
In-Reply-To: <1410229968-11638-2-git-send-email-aaron.lu@intel.com>
References: <1410229968-11638-1-git-send-email-aaron.lu@intel.com>
	<1410229968-11638-2-git-send-email-aaron.lu@intel.com>
Date: Tue, 23 Sep 2014 12:13:55 +0200
Message-ID: <CACRpkdZZ-8MAXQ_T2CYyUb0pcdS707G+NCWTc0oHJ2eqr-dcUA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio / CrystalCove: support virtual GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 4:32 AM, Aaron Lu <aaron.lu@intel.com> wrote:

> The virtual GPIO introduced in ACPI table of Baytrail-T based system is
> used to solve a problem under Windows. We do not have such problems
> under Linux so we do not actually need them. But we have to tell GPIO
> library that the Crystal Cove GPIO chip has this many GPIO pins or the
> common GPIO handler will refuse any access to those high number GPIO
> pins, which will resulted in a failure evaluation of every ACPI control
> method that is used to turn on/off power resource and/or report sensor
> temperatures.
>
> Due to the high number of virtual GPIOs, the value of ARCH_NR_GPIOS is
> bumped from 256 to 512 to avoid failures on platforms that have various
> GPIO controllers.
>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

I have some other patch pending increasing the default GPIO# to
512, but anyhow: this needs review from someone. Where is
Lejun? Mika also reviewed last time. Someone I trust to understand
ACPI need to be involved, Rafael, Darren....

Yours,
Linus Walleij
