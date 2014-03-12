Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaCLBXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:23:52 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:38891 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbaCLBXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:23:50 -0400
MIME-Version: 1.0
In-Reply-To: <2274545.CyQ67zvVqo@avalon>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
	<1802214.NxZUiJcWLG@avalon>
	<CAMuHMdVOUuFsObEag_MwUT_jaqfOHMEcUScrkbaTEitmyJr+NQ@mail.gmail.com>
	<2274545.CyQ67zvVqo@avalon>
Date: Wed, 12 Mar 2014 10:23:48 +0900
Message-ID: <CANqRtoRR9Q8Q=ACqhnLBpTavn0K5cD1=dBkjkfZ8kb+H68GuOw@mail.gmail.com>
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

On Wed, Mar 12, 2014 at 1:32 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Tuesday 11 March 2014 17:23:37 Geert Uytterhoeven wrote:
>> Hi Laurent,
>>
>> On Tue, Mar 11, 2014 at 4:55 PM, Laurent Pinchart wrote:
>> > Does this require drivers/sh/pm_runtime.c to be compiled in ?
>>
>> Let's check...
>>
>> My koelsch-legacy kernel has drivers/sh/pm_runtime.c compiled in.
>> My koelsch-reference kernel hasn't.
>>
>> However, under the -reference kernel many MSTP clocks (incl. MSIOF)
>> seem to be enabled all the time, while under -legacy they are enabled and
>> disabled on demand.
>
> Is PM_RUNTIME enabled in both cases ?
>
>
> There's something fishy in there that we should try to fix without too further
> much delay. Ben Dooks has pointed out the problem a couple of months ago, but
> the discussion on the mailing list just died.

Yes, Runtime PM is not working as expected in the multiplatform case,
that is true. I propose that we keep Runtime PM disabled in the
Kconfig for R-Car Gen2 for now to keep things simple.

>From my side I see it as two separate solutions. The short term fix is
to temporarily work around drivers that depend on Runtime PM for clock
control, I propose enabling selected clocks statically using the
function introduced by this series:

[PATCH 00/03] ARM: shmobile: Break out and extend clock workaround
http://www.spinics.net/lists/arm-kernel/msg310278.html

The long term fix I'm not sure sure about, but I trust Geert to figure
it out. =)

Regardless, rushing to fix this "correctly" seems as useful to me as
dead line driven DT development....

Thanks,

/ magnus
