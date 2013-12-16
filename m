Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3LPPvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:51:55 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35619 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3LPPvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:51:52 -0500
MIME-Version: 1.0
In-Reply-To: <20131216150937.GO18769@lee--X1>
References: <1387194424-2701-1-git-send-email-lpapp@kde.org>
	<20131216134633.GI18769@lee--X1>
	<CAOMwXhOnHNrzEvf0+QRn6dGb42xR9a33joZcou3ancwSYe36Ug@mail.gmail.com>
	<20131216150937.GO18769@lee--X1>
Date: Mon, 16 Dec 2013 15:51:52 +0000
X-Google-Sender-Auth: znWkesL91KLCK89jpjSbGEDmxiM
Message-ID: <CAOMwXhNJFGiRNB4jnTrzzpSGL8XvaR1Ph_pFrdU+x+guy7Tamg@mail.gmail.com>
Subject: Re: [PATCH] mfd: (max8997) Handle the potential error for mfd_add_devices
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 3:09 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> I think you commented on the wrong patch. There has been a newer submitted.
>
> No top posting please.

Tell that to the client I need to use. IMO, making these inline posts
mandatorily when the reply is a single line makes not much sense.
Anyway, I will follow the inconvenient way.

>> > The $SUBJECT line is wrong. To see how a subsystem usually formats
>> > theirs you must do something like `git log --oneline -- <subsystem>`.
>> > And duplicate the format.
>> >
>> > Commit message?
>
> These comments are still relevant, please re-post your patch with the
> points rectified.

I really do not understand how they relevant. "Commit message?" ->
What about it? It has a pretty clear commit message. Are you now just
picking nits about "foo:" vs "(foo)" in the short line?

>> >> Signed-off-by: Laszlo Papp <lpapp@kde.org>
>> >> ---
>> >>  drivers/mfd/max8997.c | 10 +++++-----
>> >>  1 file changed, 5 insertions(+), 5 deletions(-)
>> >>
>> >> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
>> >> index 791aea3..c7cc235 100644
>> >> --- a/drivers/mfd/max8997.c
>> >> +++ b/drivers/mfd/max8997.c
>> >> @@ -227,19 +227,19 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>> >>       pm_runtime_set_active(max8997->dev);
>> >>
>> >>       max8997_irq_init(max8997);
>> >> -
>> >> -     mfd_add_devices(max8997->dev, -1, max8997_devs,
>> >> +     ret = mfd_add_devices(max8997->dev, -1, max8997_devs,
>> >>                       ARRAY_SIZE(max8997_devs),
>> >>                       NULL, 0, NULL);
>> >> +     if (ret < 0) {
>> >> +             dev_err(dev, "cannot add mfd cells\n");
>> >> +             goto err_mfd;
>> >> +     }
>> >
>> > Have you tested this patch on h/w? Did you even compile it?
>
> You must ensure to test your patches before sending to the MLs, it's
> the very least we expect.

I am not sure what point you are trying to make. Feel free to reject
the patch for this error handling. Clearly, the patch has been updated
due to a previous mistake. I would not make a fuss about an issue
which had been fixed before getting any comment.
