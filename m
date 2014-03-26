Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaCZMuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:50:04 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:48016 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaCZMuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:50:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140326090855.GP10341@e106331-lin.cambridge.arm.com>
References: <1395771564-30534-1-git-send-email-jon@ringle.org>
	<1395771564-30534-2-git-send-email-jon@ringle.org>
	<20140326090855.GP10341@e106331-lin.cambridge.arm.com>
Date: Wed, 26 Mar 2014 08:49:59 -0400
X-Google-Sender-Auth: V5xmESimmNnO5NVGqJPZNrtrubs
Message-ID: <CAMwGMjxK2C_ciW6LwdMHE5wYkOHtkP00extF1-qcZ2xYoDr=7g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] serial: sc16is7xx: Add bindings documentation for
 the SC16IS7XX UARTs
From: Jon Ringle <jon@ringle.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Ringle <jringle@gridpoint.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 5:08 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Mar 25, 2014 at 06:19:24PM +0000, jon@ringle.org wrote:
>> +- interrupt-parent: The phandle for the interrupt controller that
>> +  services interrupts for this IC.
>> +- interrupts: Specifies the interrupt source of the parent interrupt
>> +  controller. The format of the interrupt specifier depends on the
>> +  parent interrupt controller.
>
> Just describe what the device-specific interrupt logically is, not what
> the interrupts property means in general.
>

Something like this ok?:

-interrupts: Should contain the UART interrupt

>> +- clocks: phandle to the IC source clock.
>
> Nit: clocks aren't just referred to with phandles; there's a clock
> specifier too.
>
> Either correct the type here or don't mention the type at all, given
> this is a common property.
>

I'm not sure what to do here. Many of the other
devicetree/bindings/serial/*.txt use phandle verbage and also the
devicetree/bindings/clock-bindings.txt documentation for clocks refers
the type as phandle too:

==Clock consumers==

Required properties:
clocks:         List of phandle and clock specifier pairs, one pair
                for each clock input to the device.  Note: if the
                clock provider specifies '0' for #clock-cells, then
                only the phandle portion of the pair will appear.

Is something like this ok?:

clocks: reference to the source clock

Jon
