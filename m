Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab3KRXqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:46:36 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:59504 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3KRXqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:46:35 -0500
MIME-Version: 1.0
In-Reply-To: <20131118193802.GA14925@katana>
References: <20131118193802.GA14925@katana>
Date: Mon, 18 Nov 2013 15:46:34 -0800
X-Google-Sender-Auth: Phz3Jeozg1qNtHrhK_YgX-NRy-c
Message-ID: <CA+55aFxZaC=beR+dN36Sv==6fjY7SdOdwXaSHU+wnk+-oDJp4g@mail.gmail.com>
Subject: Re: [PULL REQUEST] i2c for 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 11:38 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
> here is the pull request from the i2c subsystem for 3.13:

So while resolving some fairly trivial conflicts here, I noticed that
commit a76e9bd89ae7 ("i2c: attach/detach I2C client device to the ACPI
power domain") that I got earlier through the ACPI/PM tree calls
acpi_dev_pm_detach() even when the device "->remove()" function fails.
But it only sets clientdata to NULL if it succeeds.

That looks a bit odd.

I didn't try to fix it, though. I just thought I'd point out the oddity.

                 Linus
