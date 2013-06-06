Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab3FFQd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:33:26 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:59185 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3FFQdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:33:25 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130606162011.GV19468@game.jcrosoft.org>
References: <1370503259-16618-1-git-send-email-acourbot@nvidia.com>
	<3356BC4D-EEF6-4FCA-9310-5B0727EBF288@jcrosoft.com>
	<51B0446A.4090305@nvidia.com>
	<51B0B4A2.4010104@wwwdotorg.org>
	<20130606162011.GV19468@game.jcrosoft.org>
Date: Thu, 6 Jun 2013 09:33:24 -0700
Message-ID: <CAOesGMgybYe_BBb0M4YS8tmM2C5jawf91OOyOuwwS5HSiUjPpQ@mail.gmail.com>
Subject: Re: [PATCH] simplefb: add support for a8b8g8r8 pixel format
From: Olof Johansson <olof@lixom.net>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Alex Courbot <acourbot@nvidia.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "gnurou@gmail.org" <gnurou@gmail.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 9:20 AM, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> On 10:11 Thu 06 Jun     , Stephen Warren wrote:
>> On 06/06/2013 02:12 AM, Alex Courbot wrote:
>> > On 06/06/2013 04:59 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> >>
>> >> On Jun 6, 2013, at 9:20 AM, Alexandre Courbot <acourbot@nvidia.com>
>> >> wrote:
>> >>
>> >>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>
>> No commit description? It'd be useful to at least justify this by
>> mentioning that some platform will actually use this...
>>
>> ...
>> >>> static struct simplefb_format simplefb_formats[] = {
>> >>>     { "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
>> >>> +    { "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {31, 8} },
>> >>
>> >> why don't you parse the string?
>> >>
>> >> so you will a real generic bindings
>> >
>> > Tried that already, got NACKed: https://lkml.org/lkml/2013/5/27/330
>> >
>> > The list of modes of this driver should not grow too big. Even in terms
>> > of footprint I'd say the list should remain smaller than the parsing code.
>> >
>> > What we can discuss though is whether we want to keep this a8b8g8r8
>> > syntax or switch to something more standard, say "rgba8888".
>>
>> I would prefer to keep the syntax of the new formats consistent, so that
>> if we ever do add format-parsing code rather than table-based lookup,
>> all the existing formats will continue to work unchanged, without any
>> kind of fallback lookup table.
>
> I do prefer a format-parsing than any long lookup table that take time at boot
> time

We're talking about adding a bunch of code instead of one line in a
table. Sorry, I NACK your NACK. If we get more entries we'll add the
parser, but not just for this.

If you want to make a framebuffer-subsystem generic and shared helper,
go ahead. I'm sure simplefb will move over to it when it's available.

Until then:

Acked-by: Olof Johansson <olof@lixom.net>



-Olof
