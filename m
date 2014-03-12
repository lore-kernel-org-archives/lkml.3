Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaCLL2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:28:12 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:49930 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaCLL2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:28:10 -0400
MIME-Version: 1.0
In-Reply-To: <1972290.yxP8Fj4BuZ@avalon>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
	<2274545.CyQ67zvVqo@avalon>
	<CANqRtoRR9Q8Q=ACqhnLBpTavn0K5cD1=dBkjkfZ8kb+H68GuOw@mail.gmail.com>
	<1972290.yxP8Fj4BuZ@avalon>
Date: Wed, 12 Mar 2014 20:28:08 +0900
Message-ID: <CANqRtoQ7-=_UVrj1FarF2CaGWTLNUhrWOJJ5-Poncp7EdkhqPw@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi: sh-msiof: Convert to spi core auto_runtime_pm framework
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Mark Brown <broonie@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Mar 12, 2014 at 8:26 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> On Wednesday 12 March 2014 10:23:48 Magnus Damm wrote:
>> On Wed, Mar 12, 2014 at 1:32 AM, Laurent Pinchart wrote:
>> > On Tuesday 11 March 2014 17:23:37 Geert Uytterhoeven wrote:
>> >> Hi Laurent,
>> >>
>> >> On Tue, Mar 11, 2014 at 4:55 PM, Laurent Pinchart wrote:
>> >> > Does this require drivers/sh/pm_runtime.c to be compiled in ?
>> >>
>> >> Let's check...
>> >>
>> >> My koelsch-legacy kernel has drivers/sh/pm_runtime.c compiled in.
>> >> My koelsch-reference kernel hasn't.
>> >>
>> >> However, under the -reference kernel many MSTP clocks (incl. MSIOF)
>> >> seem to be enabled all the time, while under -legacy they are enabled and
>> >> disabled on demand.
>> >
>> > Is PM_RUNTIME enabled in both cases ?
>> >
>> > There's something fishy in there that we should try to fix without too
>> > further much delay. Ben Dooks has pointed out the problem a couple of
>> > months ago, but the discussion on the mailing list just died.
>>
>> Yes, Runtime PM is not working as expected in the multiplatform case,
>> that is true. I propose that we keep Runtime PM disabled in the
>> Kconfig for R-Car Gen2 for now to keep things simple.
>
> Isn't it ? I thought it was only broken with regard to clocks, but I might be
> missing something.

Perhaps the correct way to put it is that we have not yet figured out
how to enable Runtime PM in a way that is suitable for multiplatform.
Which means that clocks are behaving differently in the legacy case
and in the multiplatform case.

Thanks,

/ magnus
