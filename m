Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaKEU6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:58:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59574 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750867AbaKEU6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:58:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Timur Tabi <timur@codeaurora.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Date: Wed, 05 Nov 2014 22:19:09 +0100
Message-ID: <3242341.BG0xCMgUSF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <545959A8.7010305@codeaurora.org>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <3210901.7DuAVnBdHS@vostro.rjw.lan> <545959A8.7010305@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 04:56:40 PM Timur Tabi wrote:
> On 11/04/2014 05:13 PM, Rafael J. Wysocki wrote:
> > Well, first of all, you won't use phandles with ACPI.:-)
> 
> Yes, which makes things complicated for me.  The pinctrl binding makes 
> heavy use of phandles, so it will be a challenge to come up with a 
> substitue.
> 
> > That seems to be the case in which some ACPI-specific code would need to be
> > written.  In ACPI, instead of the list of phandles you'll have a list of
> > references to device objects that you can walk in an analogous way.
> 
> Can you point me to an example Linux driver that parses references?

The GPIO subsystem does that, but it probably is too complicated for your case,
because ACPI has its own native way of representing GPIOs and what we do there
is to translate the ACPI way into what the GPIO core expects.  Not exactly
straightforward, that.

Anyway, if you want me to describe it to you, please let me know.

For pinctrl we don't have any "native ACPI way" of representing things, so
we'll need to start with the DT binding directly.  That's why I asked about it.

[cut]

> > And it looks like we'll need a device_property_read_string_index().:-)
> 
> Multi-string properties are also very popular in device tree.

Those we do handle already.

> >
> > BTW, where's the pinctrl binding documented?
> 
> Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

Thanks!

Rafael

