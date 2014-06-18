Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbaFRFFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:05:20 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:44934 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933822AbaFRFFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Ue9OBkXtii4aKrCbKPd--7ZRN_G0pw2ZtX89mcz_hfzQ@mail.gmail.com>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
	<1402954800-28215-9-git-send-email-dianders@chromium.org>
	<CAPnjgZ3GhvHog5Pb3_DxYSWF0t4mgR=7HBe2KrfKcsJ=zwmFhQ@mail.gmail.com>
	<CAD=FV=Ue9OBkXtii4aKrCbKPd--7ZRN_G0pw2ZtX89mcz_hfzQ@mail.gmail.com>
Date: Tue, 17 Jun 2014 22:05:14 -0700
X-Google-Sender-Auth: WDxor43AwdQ4nK6RTVwyQCMDKtc
Message-ID: <CAPnjgZ22q3-+YGPP3=GeYgk6fxCaaOJV5RZbViiKPgga_bRtGg@mail.gmail.com>
Subject: Re: [PATCH 08/10] mfd: cros_ec: cleanup: Remove EC wrapper functions
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
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 17 June 2014 21:27, Doug Anderson <dianders@chromium.org> wrote:
> Simon,
>
> On Tue, Jun 17, 2014 at 8:42 PM, Simon Glass <sjg@chromium.org> wrote:
>>> diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
>>> index 4083796..dc37b6b 100644
>>> --- a/drivers/input/keyboard/cros_ec_keyb.c
>>> +++ b/drivers/input/keyboard/cros_ec_keyb.c
>>> @@ -191,8 +191,18 @@ static void cros_ec_keyb_close(struct input_dev *dev)
>>>
>>>  static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, uint8_t *kb_state)
>>>  {
>>> -       return ckdev->ec->command_recv(ckdev->ec, EC_CMD_MKBP_STATE,
>>> -                                         kb_state, ckdev->cols);
>>> +       int ret;
>>> +       struct cros_ec_command msg = {
>>> +               .version = 0,
>>> +               .command = EC_CMD_MKBP_STATE,
>>> +               .outdata = NULL,
>>> +               .outsize = 0,
>>> +               .indata = kb_state,
>>> +               .insize = ckdev->cols,
>>> +       };
>>> +
>>> +       ret = ckdev->ec->cmd_xfer(ckdev->ec, &msg);
>>
>> Do we need ret?
>
> No.  If you wish I will spin without it.  Let me know.
>
> Note that locally this code includes a comment between the above and the return:
>   /* FIXME: This assumes msg.result == EC_RES_SUCCESS */

It's not important to me, and you've explained the other question.

Reviewed-by: Simon Glass <sjg@chromium.org>
