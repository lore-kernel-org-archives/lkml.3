Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaFREQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 00:16:50 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:42192 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaFREQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 00:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAPnjgZ0Ofds_atZRVxfM4RCtiDNjbZpcdAvZBM_fCbniKTFmig@mail.gmail.com>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
	<1402954800-28215-5-git-send-email-dianders@chromium.org>
	<CAPnjgZ0Ofds_atZRVxfM4RCtiDNjbZpcdAvZBM_fCbniKTFmig@mail.gmail.com>
Date: Tue, 17 Jun 2014 21:16:47 -0700
X-Google-Sender-Auth: 99_DlLluWZ4742uELaXOVQJNWBw
Message-ID: <CAD=FV=V4Diapvi9utBUH-nwsKunCxOqPVgp8c6_e6P5+qwgYFw@mail.gmail.com>
Subject: Re: [PATCH 04/10] mfd: cros_ec: Tweak struct cros_ec_device for clarity
From: Doug Anderson <dianders@chromium.org>
To: Simon Glass <sjg@chromium.org>
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

Simon,

On Tue, Jun 17, 2014 at 8:35 PM, Simon Glass <sjg@chromium.org> wrote:
> Hi Doug,
>
> On 16 June 2014 14:39, Doug Anderson <dianders@chromium.org> wrote:
>> From: Bill Richardson <wfrichar@chromium.org>
>>
>> The members of struct cros_ec_device were improperly commented, and
>> intermixed the private and public sections. This is just cleanup to make it
>> more obvious what goes with what.
>>
>> [dianders: left lock in the structure but gave it the name that will
>> eventually be used.]
>>
>> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/mfd/cros_ec.c       |  2 +-
>>  drivers/mfd/cros_ec_i2c.c   |  4 +--
>>  drivers/mfd/cros_ec_spi.c   | 10 +++----
>>  include/linux/mfd/cros_ec.h | 65 ++++++++++++++++++++++++---------------------
>>  4 files changed, 43 insertions(+), 38 deletions(-)
>>
>> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
>> index bd6f936..a9eede5 100644
>> --- a/drivers/mfd/cros_ec.c
>> +++ b/drivers/mfd/cros_ec.c
>> @@ -57,7 +57,7 @@ static int cros_ec_command_sendrecv(struct cros_ec_device *ec_dev,
>>         msg.in_buf = in_buf;
>>         msg.in_len = in_len;
>>
>> -       return ec_dev->command_xfer(ec_dev, &msg);
>> +       return ec_dev->cmd_xfer(ec_dev, &msg);
>
> Why do this rename? It makes it different from the other members.

All I know of the history of this change is at
<http://crosreview.com/57061>.  My best guess is that Bill was trying
to differentiate public vs. private function pointers.  Perhaps he
will chime in.

If it helps the other command_xxx() function pointers are removed in
the later "mfd: cros_ec: cleanup: Remove EC wrapper functions"

If you wish I can skip this rename, just let me know and it won't be
too much trouble.

-Doug
