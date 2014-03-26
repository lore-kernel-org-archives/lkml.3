Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaCZOjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:39:32 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:53157 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaCZOj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <5332AF10.90109@biereigel.de>
References: <532FE3B2.9060808@biereigel-wb.de> <CAOLK0pxh4b3uzjD4jaPssD66K8g33uqahV1SzOAJAmQmnY4XqQ@mail.gmail.com>
 <533014B1.4030307@biereigel-wb.de> <CAOLK0pyOV50Vqt+bX_QpH_tjL=8eWwvu+O70EvTOZ+ixWZmr3Q@mail.gmail.com>
 <CAGf84Q+9RcQqi=YYvF8X8EJzbtk7dJYTxScaZN4347U+POQ4AQ@mail.gmail.com>
 <5331E5EB.5000304@biereigel-wb.de> <5331E9E4.4050201@gmail.com>
 <5332099B.8090305@gmail.com> <5332AF10.90109@biereigel.de>
From: Kieran Clancy <clancy.kieran@gmail.com>
Date: Thu, 27 Mar 2014 01:08:58 +1030
Message-ID: <CAGf84QJU+RKXV4AyQ7QBTKjpdPm3AYLtWTFio+-r3j8wyoEokA@mail.gmail.com>
Subject: Re: [REGRESSION 3.14-rc6] Samsung N150 lid does not "open" after
 suspend to RAM.
To: Stefan Biereigel <stefan@biereigel.de>
Cc: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Stefan Biereigel <security@biereigel-wb.de>,
        Lan Tianyu <lantianyu1986@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        San Zamoyski <san@plusnet.pl>, "D. Jansen" <dennis.jansen@web.de>,
        "Maurizio D'Addona" <mauritiusdadd@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 9:12 PM, Stefan Biereigel <stefan@biereigel.de> wrote:
>
> I don't know if it is a valid idea, but maybe it would be ok to process
> events after resume in general, and only throw away events on those
> platforms that continue to log events while in standby (Samsung 5/7/9)?

We can give it a shot!

It may even be that on Samsung 5/7/9 there is no harm in processing
the events instead of discarding them.

Here's a patch that we can try for that:

http://kieranclancy.com/tmp/2014/03/ec_clear_process.patch

I'm going to have to clear up some hard drive space before I can
compile a kernel with it (curse this tiny SSD), but if anyone else
wants to give it a shot please feel free.

One thing I am still trying to think about is that Stefan's system
must be about to check and process this EC event anyway, but we
discard it first. I wonder if there is some difference in state (e.g.
EC status bits) here that we might detect.

Failing all that, it might be easier to just whitelist this product
rather than try to find every series 5/7/9/?/... Samsung product name.
Something like this:

http://kieranclancy.com/tmp/2014/03/ec_clear_exclude_N150P.patch (not
intended for use with other patch, they are mutually exclusive
approaches)

> But after all, it would be better to find the command to tell the EC to
> stop recording events and issue that before going to sleep. Is there any
> way to find that command (for example on Windows)? Maybe that one is so
> generic that we can issue it to all ECs, regardless of if it would
> continue to log events during sleep.

It would be great to know what Windows does here, but even then we
still need to be able to clear a jammed EC. You can still find posts
around the internet where Windows users who've never touched Linux
have these same kind of problems with their Samsung laptops. My guess
is it only takes one blue screen of death or something where the EC
isn't shut down properly, the EC fills up and then it's more or less a
permanent state until the EC is cleared manually.

Thanks again for your testing, Stefan.

Kieran.
