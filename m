Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaHIRet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:34:49 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:47531 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaHIRep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140809135557.GA4837@katana>
References: <20140809135557.GA4837@katana>
Date: Sat, 9 Aug 2014 10:34:44 -0700
X-Google-Sender-Auth: wVh6E0bJMAE5mfOhNraSxWIMGC0
Message-ID: <CA+55aFy0UVY=60pCr85AvhedfO-MEoD-iMGdWmBYt8fKgF7kWA@mail.gmail.com>
Subject: Re: [PULL REQUEST] i2c for 3.17
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Cc: linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 6:56 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
> here is the pull request for 3.17 for the I2C subsystem. Highlights:

Lowlight: selecting ACPI support (which used to be the default if ACPI
was enabled) now forces i2c to be built-in.

I've pulled this, but it's broken. You need to fix it someway.

The reason for this is

  config I2C
         tristate "I2C support"
  ...
  config I2C_ACPI
         bool "I2C ACPI support"
         select I2C
         depends on ACPI
   ...

where if I2C_APCI is on (y), then that "select I2C" will cause I2C to
be upgraded to 'y' as well.

This seems to be intentional, judging by the commit message, but it's
wrong. Distributions etc generally compile i2c as a module, and you've
now broken that.

This is a regression. Change the "select I2C" to a "depends on I2C",
and test the end result. Don't force people to build things into the
kernel.

                 Linus
