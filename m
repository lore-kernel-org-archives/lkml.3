Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbaFRDf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:35:58 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:59950 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbaFRDf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:35:57 -0400
MIME-Version: 1.0
In-Reply-To: <1402954800-28215-5-git-send-email-dianders@chromium.org>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
	<1402954800-28215-5-git-send-email-dianders@chromium.org>
Date: Tue, 17 Jun 2014 20:35:56 -0700
X-Google-Sender-Auth: B9yUMpWKWH4nqURSZlIjcs-RuaY
Message-ID: <CAPnjgZ0Ofds_atZRVxfM4RCtiDNjbZpcdAvZBM_fCbniKTFmig@mail.gmail.com>
Subject: Re: [PATCH 04/10] mfd: cros_ec: Tweak struct cros_ec_device for clarity
From: Simon Glass <sjg@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 16 June 2014 14:39, Doug Anderson <dianders@chromium.org> wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>
> The members of struct cros_ec_device were improperly commented, and
> intermixed the private and public sections. This is just cleanup to make it
> more obvious what goes with what.
>
> [dianders: left lock in the structure but gave it the name that will
> eventually be used.]
>
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mfd/cros_ec.c       |  2 +-
>  drivers/mfd/cros_ec_i2c.c   |  4 +--
>  drivers/mfd/cros_ec_spi.c   | 10 +++----
>  include/linux/mfd/cros_ec.h | 65 ++++++++++++++++++++++++---------------------
>  4 files changed, 43 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> index bd6f936..a9eede5 100644
> --- a/drivers/mfd/cros_ec.c
> +++ b/drivers/mfd/cros_ec.c
> @@ -57,7 +57,7 @@ static int cros_ec_command_sendrecv(struct cros_ec_device *ec_dev,
>         msg.in_buf = in_buf;
>         msg.in_len = in_len;
>
> -       return ec_dev->command_xfer(ec_dev, &msg);
> +       return ec_dev->cmd_xfer(ec_dev, &msg);

Why do this rename? It makes it different from the other members.

Regards,
Simon
