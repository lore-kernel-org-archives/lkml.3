Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3CKQFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:05:37 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:57762 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3CKQFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:05:35 -0400
MIME-Version: 1.0
In-Reply-To: <1360957573-864-1-git-send-email-dianders@chromium.org>
References: <1360887677-20758-1-git-send-email-dianders@chromium.org>
	<1360957573-864-1-git-send-email-dianders@chromium.org>
Date: Mon, 11 Mar 2013 09:05:33 -0700
X-Google-Sender-Auth: tZP0m9WXgOqmMLnHoLyxQlSJlcQ
Message-ID: <CAD=FV=UOeWaLDkycm40vGy3jPT8cPagr8WAjHG5Ukckd2+kTcw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>, Olof Johansson <olof@lixom.net>
Cc: Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        "bhushan.r" <bhushan.r@samsung.com>,
        "sreekumar.c" <sreekumar.c@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram,

On Fri, Feb 15, 2013 at 11:46 AM, Doug Anderson <dianders@chromium.org> wrote:
> The i2c-arbitrator-cros-ec driver implements the arbitration scheme
> that the Embedded Controller (EC) on the ARM Chromebook expects to use
> for bus multimastering.  This i2c-arbitrator-cros-ec driver could also
> be used in other places where standard I2C bus arbitration can't be
> used and two extra GPIOs are available for arbitration.
>
> This driver is based on code that Simon Glass added to the i2c-s3c2410
> driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
> mux driver is as suggested by Grant Likely.  See
> <https://patchwork.kernel.org/patch/1877311/> for some history.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes in v3:
> - Handle of_find_i2c_adapter_by_node() failure more properly by
>   changing init order.
> - Don't warn on -EPROBE_DEFER from calls that could return it.
> - Move to module_platform_driver().  As we pull in parts of the system
>   that rely on devices under this i2c bus we'll need to make sure they
>   can handle the fact that they'll be initted later now.
>
> Changes in v2:
> - Renamed to i2c-arbitrator-cros-ec.
> - Documented "microsecond" properties as optional; removed
>   "bus-arbitration" prefix since it was just extra wordy.
> - Split GPIOs into two properties to make it cleaner.
> - Capitalized I2C in freeform text.
> - Get 'active low' from device tree.
>
>  .../bindings/i2c/i2c-arbitrator-cros-ec.txt        |  76 +++++++
>  drivers/i2c/muxes/Kconfig                          |  11 +
>  drivers/i2c/muxes/Makefile                         |   2 +
>  drivers/i2c/muxes/i2c-arbitrator-cros-ec.c         | 222 +++++++++++++++++++++
>  4 files changed, 311 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-arbitrator-cros-ec.txt
>  create mode 100644 drivers/i2c/muxes/i2c-arbitrator-cros-ec.c

Is there anything you'd like done before landing this patch for 3.10?
It's been reviewed by Stephen Warren (thanks Stephen!).  From what I
remember from Olof's talk at ELC it seems like the best thing would be
to merge part 1 through i2c tree and then ask Olof to merge parts 2
and 3 (the dts bits) through the arm-soc tree.

I believe you could also add a "Tested-by" from Naveen to patch #1.
He sent a tested by for parts 2 and 3 so must have also tested part 1
(the other two don't function without it).

Please let me know--I'm happy to spin with any changes needed.  :)

-Doug
