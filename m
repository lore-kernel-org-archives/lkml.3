Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaKDWwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:52:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49931 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751229AbaKDWwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:52:22 -0500
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
Date: Wed, 05 Nov 2014 00:13:06 +0100
Message-ID: <3210901.7DuAVnBdHS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54595590.7080603@codeaurora.org>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <54595416.1020205@codeaurora.org> <54595590.7080603@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 04:39:12 PM Timur Tabi wrote:
> On 11/04/2014 04:32 PM, Timur Tabi wrote:
> >
> > There are lots of situations where you don't know the size of the
> > property in advance (e.g. strings), and drivers use of_find_property()
> > or of_get_property() to pre-allocate a buffer or to verify that the
> > property is correctly formed in the device tree.
> 
> To follow-up, I have this problem right now with pinctrl_dt_to_map(). 
> The pinctrl-%d property in the device tree is an array of phandles.  The 
> array can be any size, and pinctrl_dt_to_map() queries the size of the 
> property to determine how many phandles there are.  It iterates over all 
> of them.  How do I support that with device_property_read_u32_array()? 
> That function expects to be told how many phandles there are, and it 
> doesn't even tell me if there are more or fewer than the number I've given.

Well, first of all, you won't use phandles with ACPI. :-)

That seems to be the case in which some ACPI-specific code would need to be
written.  In ACPI, instead of the list of phandles you'll have a list of
references to device objects that you can walk in an analogous way.  I'm
not sure how much of that code can be shared between DT and ACPI ATM, but
it looks like at least some of it can be shared.

And it looks like we'll need a device_property_read_string_index(). :-)

BTW, where's the pinctrl binding documented?

Rafael

