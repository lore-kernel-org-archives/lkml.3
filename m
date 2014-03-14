Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaCNKxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:53:32 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41206 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaCNKxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:53:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140313151816.GR5018@intel.com>
References: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
	<1394456094-21671-6-git-send-email-mika.westerberg@linux.intel.com>
	<CACRpkdY3z-XGHwn5sQKM-8cKYHzr3_40h53032ETN6PaDW779w@mail.gmail.com>
	<20140313151816.GR5018@intel.com>
Date: Fri, 14 Mar 2014 11:53:30 +0100
Message-ID: <CACRpkdZfeGkHp8kc-Uv+5Q6xRN1NwiZD-kLWS93x0jV=kn30MA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] gpio / ACPI: Add support for ACPI GPIO operation regions
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 4:18 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Thu, Mar 13, 2014 at 03:32:01PM +0100, Linus Walleij wrote:

>> > +                       case ACPI_IO_RESTRICT_OUTPUT:
>> > +                               gpiod_direction_output(desc, pull);
>>
>> Can you explain why the fact that the line is pulled down affects the
>> default output value like this? I don't get it.
>
> That's the thing - ACPI doesn't tell us what is the initial value of the
> pin. There is no such field in GpioIo() resource.
>
> So I'm assuming here that if it says that the pin is pulled up, the default
> value will be high.

OK! So exactly that statement is what I want to see as a comment
in this switch case.

>> > +               if (function == ACPI_WRITE)
>> > +                       gpiod_set_raw_value(desc, !!((1 << i) & *value));
>>
>> What is this? How can the expression !!((1 << i) possibly evaluate to
>> anything else than "true"? I don't get it. Just (desc, *value) seem more
>> apropriate.
>
> We are dealing with multiple pins here. So for example if
> agpio->pin_table_length == 2 and *value == 0x2 we get:
>
> i == 0: !!((1 << 0) & 0x2) --> false
> i == 1: !!((1 << 1) & 0x2) --> true

Yeah, Alan already pointed out my parse error... this is OK.

Yours,
Linus Walleij
