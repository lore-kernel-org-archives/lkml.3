Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbbATPL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:11:58 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:57385 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbbATPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:11:56 -0500
MIME-Version: 1.0
In-Reply-To: <1421689454.9655.58.camel@x220>
References: <1421689454.9655.58.camel@x220>
Date: Tue, 20 Jan 2015 08:11:56 -0700
Message-ID: <CANLsYkzgiX_ZkQVEU-o4VE=LQB=daw1a3WCOkm45bdBHWg72tg@mail.gmail.com>
Subject: Re: [PATCH] coresight-etm: remove check for unknown Kconfig macro
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 January 2015 at 10:44, Paul Bolle <pebolle@tiscali.nl> wrote:
> The CoreSight ETM/PTM driver contains a check for a
> CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE macro. But there's no related
> Kconfig symbol CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE. Remove that check
> and the single line of code it hides.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Cross-compile tested only (on top of next-20150119).
>
>  drivers/coresight/coresight-etm3x.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/coresight/coresight-etm3x.c
> index 73c36696f1b6..f312dc4dd95c 100644
> --- a/drivers/coresight/coresight-etm3x.c
> +++ b/drivers/coresight/coresight-etm3x.c
> @@ -34,11 +34,7 @@
>
>  #include "coresight-etm.h"
>
> -#ifdef CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE
> -static int boot_enable = 1;
> -#else
>  static int boot_enable;
> -#endif
>  module_param_named(
>         boot_enable, boot_enable, int, S_IRUGO
>  );
> --
> 1.9.3
>

Applied - with a slight modification to keep the "module_param_named"
macro on the same line.
