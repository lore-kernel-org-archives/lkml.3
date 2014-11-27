Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaK0Njl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:39:41 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62233 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaK0Njj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:39:39 -0500
MIME-Version: 1.0
In-Reply-To: <20141126214847.GJ3443@lunn.ch>
References: <1417023640-23464-1-git-send-email-leif.lindholm@linaro.org>
 <1417023640-23464-3-git-send-email-leif.lindholm@linaro.org>
 <20141126183052.GH3443@lunn.ch> <CACxGe6tYZ8aE_TKw1cYMY5DDjpSXPSnhhAam-rG5NgdjpKJe+A@mail.gmail.com>
 <20141126214847.GJ3443@lunn.ch>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 27 Nov 2014 13:39:17 +0000
X-Google-Sender-Auth: 7mRq2LNQlIzJqDTOAQOMdw-B6P8
Message-ID: <CACxGe6v6jrwKaT0NT1jzHfbmGi2sTe9SrriTB1kib+01=C0-Lw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] of: support passing console options with stdout-path
To: Andrew Lunn <andrew@lunn.ch>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ian Campbell <ijc@debian.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 9:48 PM, Andrew Lunn <andrew@lunn.ch> wrote:
> On Wed, Nov 26, 2014 at 09:07:33PM +0000, Grant Likely wrote:
>> On Wed, Nov 26, 2014 at 6:30 PM, Andrew Lunn <andrew@lunn.ch> wrote:
>> > On Wed, Nov 26, 2014 at 05:40:40PM +0000, Leif Lindholm wrote:
>> >> Support specifying console options (like with console=ttyXN,<options>)
>> >> by appending them to the stdout-path property after a separating ':'.
>> >>
>> >> Example:
>> >>         stdout-path = "uart0:115200";
>> >
>> > Hi Leif
>> >
>> > This should be documented somewhere under
>> > Documentation/devicetree/bindings/
>> >
>> > Not sure where thought. Maybe a top level chosen.txt?
>>
>> Actually, this one doesn't. It is already documented in ePAPR
>
> Hi Grant
>
> Humm, do i have an old version of ePAPR?
>
> All i see is that in Table 3-4 It says:
>
> stdout-path O <string> A string that specifies the full path to the
>                        node representing the device to be used for
>                        boot console output. If the character ":" is
>                        present in the value it terminates the
>                        path. The value may be an alias.
>
>                        If the stdin-path property is not specified,
>                        stdout-path should be assumed to define the input device.
>
> So what is before the : is defined. What comes afterwards,
> baudrate/parity/bits/flow control does not appear to the defined in
> ePAPR. Should we not document the extension being added here?

Ah, good point. I had thought you were referring to the argument separator.

Yes, the extension should be documented. The binding can actually be
driver specific, but there is little to no reason for each uart driver
to be unique in this regard and the b/p/b/f format is very well
established, so I agree. Other drivers, say video out or netcon, could
use different arguments.

g.
