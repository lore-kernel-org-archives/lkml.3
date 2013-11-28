Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3K1H2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:28:53 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57396 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3K1H2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:28:48 -0500
MIME-Version: 1.0
In-Reply-To: <20131127141750.B666EC404EC@trevor.secretlab.ca>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
	<CAEgOgz4yhDzy_BFiotK5Qi48sczR3PL1oPjPhNYC9O94P6AnzQ@mail.gmail.com>
	<20131127141750.B666EC404EC@trevor.secretlab.ca>
Date: Thu, 28 Nov 2013 17:28:47 +1000
X-Google-Sender-Auth: g9SbGdNtwyz78d3mX7higJbmyLI
Message-ID: <CAEgOgz4rMj2wg6xiwjo3vuQSCXYurPF3-sKifUbCUXk8amMO4A@mail.gmail.com>
Subject: Re: [RFC 9/9] of/irq: create interrupts-extended property
From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Michal Simek <monstr@monstr.eu>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 12:17 AM, Grant Likely <grant.likely@linaro.org> wrote:
> On Wed, 27 Nov 2013 19:06:35 +1000, Peter Crosthwaite <peter.crosthwaite@xilinx.com> wrote:
>> On Mon, Nov 25, 2013 at 7:32 AM, Grant Likely <grant.likely@linaro.org> wrote:
>> > On Sun, 24 Nov 2013 17:04:52 +1000, Peter Crosthwaite <peter.crosthwaite@xilinx.com> wrote:
>> >> On Wed, Nov 13, 2013 at 4:14 PM, Grant Likely <grant.likely@linaro.org> wrote:
>> >> > On Wed, 13 Nov 2013 09:17:01 +1000, Peter Crosthwaite <peter.crosthwaite@xilinx.com> wrote:
>> >> >> It's going to get a little verbose once you start making multiple
>> >> >> connections as you need one mux per wire. Perhaps it could be cleaned
>> >> >> up by making the foo_irq_mux node(s) a child of foo?
>> >> >
>> >> > It could, but then you need some way of attaching a driver to that node,
>> >> > and that would require building knowledge into the driver again.
>> >> >
>> >> > Can you boil it down to a couple of concrete examples? What is a
>> >> > specific example of how the platform should decide which interrupt line
>> >> > to use?
>> >> >
>> >>
>> >> So i've spent some time playing with this. I now have a booting kernel
>> >> with multiple root interrupt controllers and peripheral devices
>> >> multiply-connected to both root controllers. But only one on of the
>> >> controllers is used by Linux (as linux being able to use multiple
>> >> intcs is a non-trivial problem). So the scheme I am using is to have
>> >> one of these root intc's marked as disabled via
>> >
>> > Multiple intc's should be a solved problem. What issue are you seeing?
>> > Or is this a microblaze specific problem?
>> >
>>
>> It's multiple root (i.e. have no explicit parent) interrupt
>> controllers. And linux
>> doesnt respect status = "disabled" for interrupt controllers at all it seems.
>
> That can be fixed.  :-)
>

Patches on list.

Regards,
Peter

> g.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
