Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646Ab3JPWxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:53:45 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56687 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3JPWxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:53:43 -0400
MIME-Version: 1.0
In-Reply-To: <1381963198.22110.73.camel@joe-AO722>
References: <1381962675-26876-1-git-send-email-geyslan@gmail.com>
	<1381963198.22110.73.camel@joe-AO722>
Date: Wed, 16 Oct 2013 19:53:42 -0300
Message-ID: <CAGG-pUQMunYkZC38DWOOiEJM3U6vG-VbJJRGMB3PSfOZYvDKXg@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: input: mouse: Remove useless casting in cypress_ps2.c
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: dmitry.torokhov@gmail.com, dudl@cypress.com, kamal@canonical.com,
        mario_limonciello@dell.com, git@status.e4ward.com,
        linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/16 Joe Perches <joe@perches.com>:
> On Wed, 2013-10-16 at 19:31 -0300, Geyslan G. Bem wrote:
>> Get rid of unnecessary (void *) casting in 'cypress_init' function.
> []
>> diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
> []
>> @@ -680,7 +680,7 @@ int cypress_init(struct psmouse *psmouse)
>>       struct cytp_data *cytp;
>>
>>       cytp = (struct cytp_data *)kzalloc(sizeof(struct cytp_data), GFP_KERNEL);
>> -     psmouse->private = (void *)cytp;
>> +     psmouse->private = cytp;
>
> If you are going to remove useless casts, please
> also remove the unnecessary kzalloc cast too.
>
>

Joe, thanks for reply. Actually I did it and receive this reply from Dmitry:

       struct cytp_data *cytp;

 -     cytp = (struct cytp_data *)kzalloc(sizeof(struct cytp_data), GFP_KERNEL);
 +     cytp = kzalloc(sizeof(struct cytp_data), GFP_KERNEL);

I already have a patch for this from Jingoo Han in my queue.

       psmouse->private = (void *)cytp;

But this cast is also not needed, so if you could send me a patch for it
I'd appreciate that.
