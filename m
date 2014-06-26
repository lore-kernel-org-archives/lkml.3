Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbaFZPqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:46:18 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:33275 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaFZPqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:46:16 -0400
MIME-Version: 1.0
In-Reply-To: <1403785148-20792-3-git-send-email-ch.naveen@samsung.com>
References: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com>
	<1403785148-20792-3-git-send-email-ch.naveen@samsung.com>
Date: Thu, 26 Jun 2014 08:46:14 -0700
X-Google-Sender-Auth: KIgWyBBEUjQtRy1LELSeWz5cTws
Message-ID: <CAD=FV=W=e-5LJRacxA-sSUUn8cBB5oCHJkwz=Py7iU2fdERVRA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: DTS: Add NTC thermistor nodes to Exynos5250
 based Snow
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        "cpgs ." <cpgs@samsung.com>, Tushar Behera <tushar.b@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Thu, Jun 26, 2014 at 5:19 AM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> Exynos5250 based Snow board has 4 NTC thermistors to measure
> temperatures at various points on the board.
>
> IIO based ADC becomes the parent and NTC thermistors are the childs,
> via the HWMON interface.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Posted earlier by Doug Anderson @ https://lkml.org/lkml/2013/3/27/453
>
> This patch depends on (1/4 and 2/4 patches of) patchset posted
> http://www.spinics.net/lists/linux-iio/msg13486.html
> Which were applied on to Guenter Roeck's tree.
>
> cat sysfs entries exported by hwmon for 4 thermistors
> and verified the values on Snow.
>
>  arch/arm/boot/dts/exynos5250-snow.dts |   34 +++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)

NAK.

The first chunk of exynos5250-snow devices have the thermistors
populated, but a huge chunk of devices also _don't_ have them
populated.

If I remember my history properly, rev3 and earlier all had
thermistors.  Some of rev4 might have thermistors (I never got a clear
answer).  ...and rev5 definitely doesn't have resistors.  Aside from
thermistors there's no good reason to differentiate rev3 and rev4
(they just have different memory).  The upstream kernel may eventually
need to differentiate rev4 and rev5 since they have a different audio
codec.

See <https://chromium-review.googlesource.com/#/c/170841/> for some
descriptions of the different revisions of snow and how they were
handled in the Chrome OS tree.

See <https://chromium-review.googlesource.com/#/c/186357/> for
thermistors talk.  Patch set #1 actually split out rev3, but we then
decided that we really didn't need to use the thermistors on any of
the revisions so the later patchsets just totally take them out.

-Doug
