Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaFKPLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:11:48 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:36721 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbaFKPLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:11:45 -0400
MIME-Version: 1.0
In-Reply-To: <1402483068.3798.82.camel@x220>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
	<1398879850-9111-6-git-send-email-dianders@chromium.org>
	<20140520084602.GF24991@lee--X1>
	<1402483068.3798.82.camel@x220>
Date: Wed, 11 Jun 2014 08:11:44 -0700
X-Google-Sender-Auth: JQt_2xqJL4MHdef2NxPeLKTnBig
Message-ID: <CAD=FV=XL9tnEqza8Zx8mt_Z7-bj8TCzdeyHMhnpewKp_1CR-ig@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] mfd: cros_ec: Sync to the latest
 cros_ec_commands.h from EC sources
From: Doug Anderson <dianders@chromium.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@chromium.org>,
        Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Olof Johansson <olof@lixom.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Wed, Jun 11, 2014 at 3:37 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2014-05-20 at 09:46 +0100, Lee Jones wrote:
>> On Wed, 30 Apr 2014, Doug Anderson wrote:
>> > From: Bill Richardson <wfrichar@chromium.org>
>> >
>> > This just updates include/linux/mfd/cros_ec_commands.h to match the
>> > latest EC version (which is the One True Source for such things).  See
>> > <https://chromium.googlesource.com/chromiumos/platform/ec>

I believe most of your questions are answered by checking out the git
tree referenced above.  ...but see below for details.  This header is
a common interface between the kernel and the EC.


>> > [dianders: took today's ToT version from the Chromium OS EC; deleted
>> > references to cros_ec_dev and cros_ec_lpc since those aren't upstream
>> > yet]
>> >
>> > Signed-off-by: Bill Richardson <wfrichar@chromium.org>
>> > Signed-off-by: Doug Anderson <dianders@chromium.org>
>> > Acked-by: Lee Jones <lee.jones@linaro.org>
>> > Reviewed-by: Simon Glass <sjg@chromium.org>
>> > Tested-by: Andrew Bresticker <abrestic@chromium.org>
>> > Tested-by: Stephen Warren <swarren@nvidia.com>
>> > ---
>> > Changes in v3: None
>> > Changes in v2: None
>> >
>> >  drivers/mfd/cros_ec.c                |    2 +-
>> >  include/linux/mfd/cros_ec.h          |    4 +-
>> >  include/linux/mfd/cros_ec_commands.h | 1128 +++++++++++++++++++++++++++++++---
>> >  3 files changed, 1059 insertions(+), 75 deletions(-)
>>
>> Applied, thanks.
>
> This patch is included in linux-next since next-20140521. I'm not sure
> why I waited three weeks before sending this question...
>
>> > [...]
>> > diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cros_ec_commands.h
>> > index 86fd069..7853a64 100644
>> > --- a/include/linux/mfd/cros_ec_commands.h
>> > +++ b/include/linux/mfd/cros_ec_commands.h
>>> [...]
>> > @@ -1206,14 +1865,231 @@ struct ec_params_force_idle {
>> > [...]
>> > +/*
>> > + * Known param numbers are defined here. Ranges are reserved for board-specific
>> > + * params, which are handled by the particular implementations.
>> > + */
>> > +enum charge_state_params {
>> > +   CS_PARAM_CHG_VOLTAGE,         /* charger voltage limit */
>> > +   CS_PARAM_CHG_CURRENT,         /* charger current limit */
>> > +   CS_PARAM_CHG_INPUT_CURRENT,   /* charger input current limit */
>> > +   CS_PARAM_CHG_STATUS,          /* charger-specific status */
>> > +   CS_PARAM_CHG_OPTION,          /* charger-specific options */
>> > +   /* How many so far? */
>> > +   CS_NUM_BASE_PARAMS,
>> > +
>> > +   /* Range for CONFIG_CHARGER_PROFILE_OVERRIDE params */
>
> CONFIG_CHARGER_PROFILE_OVERRIDE doesn't match anything in linux-next. Is
> a Kconfig symbol CHARGER_PROFILE_OVERRIDE perhaps queued somewhere?

This is a config option on the ChromeOS EC
<https://chromium.googlesource.com/chromiumos/platform/ec>.  Doing a
grep there:

board/samus/board.h:#define CONFIG_CHARGER_PROFILE_OVERRIDE
common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
driver/battery/samus.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
driver/battery/samus.c:#endif   /* CONFIG_CHARGER_PROFILE_OVERRIDE */
include/config.h:#undef CONFIG_CHARGER_PROFILE_OVERRIDE
include/ec_commands.h:  /* Range for CONFIG_CHARGER_PROFILE_OVERRIDE params */
test/test_config.h:#define CONFIG_CHARGER_PROFILE_OVERRIDE


>> > +   CS_PARAM_CUSTOM_PROFILE_MIN = 0x10000,
>> > +   CS_PARAM_CUSTOM_PROFILE_MAX = 0x1ffff,
>> > +
>
> I guess so, because these two constants aren't used anywhere.

A grep from the EC sources:

common/charge_state_v2.c:               if (in->get_param.param >=
CS_PARAM_CUSTOM_PROFILE_MIN &&
common/charge_state_v2.c:               if (in->set_param.param >=
CS_PARAM_CUSTOM_PROFILE_MIN &&
driver/battery/samus.c:#define PARAM_FASTCHARGE
(CS_PARAM_CUSTOM_PROFILE_MIN + 0)
include/ec_commands.h:  CS_PARAM_CUSTOM_PROFILE_MIN = 0x10000,
test/sbs_charging_v2.c: if (param == CS_PARAM_CUSTOM_PROFILE_MIN) {
test/sbs_charging_v2.c: if (param == CS_PARAM_CUSTOM_PROFILE_MIN) {
test/sbs_charging_v2.c: params.get_param.param = CS_PARAM_CUSTOM_PROFILE_MIN;
test/sbs_charging_v2.c: params.set_param.param = CS_PARAM_CUSTOM_PROFILE_MIN;
util/ectool.c:          printf("  0x%x - 0x%x\n", CS_PARAM_CUSTOM_PROFILE_MIN,

-Doug
