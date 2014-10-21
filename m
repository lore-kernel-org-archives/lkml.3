Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbaJURob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:44:31 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:60837 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbaJURo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:44:29 -0400
MIME-Version: 1.0
In-Reply-To: <5ee64319b16d00f8fb800607b1e304a1@hardeman.nu>
References: <1413714113-7456-1-git-send-email-tomas.melin@iki.fi>
	<1413714113-7456-2-git-send-email-tomas.melin@iki.fi>
	<5ee64319b16d00f8fb800607b1e304a1@hardeman.nu>
Date: Tue, 21 Oct 2014 20:44:28 +0300
X-Google-Sender-Auth: niJkvSGn5kA831HJxhM6wVeiSfc
Message-ID: <CACraW2q4ki+6hscwL_am536fiL3BS4F+HXN7AN4snbuPveCzHg@mail.gmail.com>
Subject: Re: [PATCH 2/2] [media] rc-core: change enabled_protocol default setting
From: Tomas Melin <tomas.melin@iki.fi>
To: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, james.hogan@imgtec.com,
        =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 5:12 PM, David Härdeman <david@hardeman.nu> wrote:
> On 2014-10-19 12:21, Tomas Melin wrote:
>>
>> Change default setting for enabled protocols.
>> Instead of enabling all protocols, disable all except lirc during
>> registration.
>> Reduces overhead since all protocols not handled by default.
>> Protocol to use will be enabled when keycode table is written by
>> userspace.
>
>
> I can see the appeal in this, but now you've disabled automatic decoding for
> the protocol specified by the keymap for raw drivers? So this would also be
> a change, right?

Yes, you are right. Atleast it potentially still could change expected
behaviour.

>
> I agree with Mauro that the "proper" long-term fix would be to teach the
> LIRC userspace daemon to enable the lirc protocol as/when necessary, but
> something similar to the patch below (but lirc + keymap protocol...if that's
> possible to implement in a non-intrusive manner, I haven't checked TBH)
> might be a good idea as an interim measure?
>
I think it looks feasible to implement that way. I'll look in to it
and send a new patch series.

Tomas

>
>
>>
>> Signed-off-by: Tomas Melin <tomas.melin@iki.fi>
>> ---
>>  drivers/media/rc/rc-ir-raw.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
>> index a118539..63d23d0 100644
>> --- a/drivers/media/rc/rc-ir-raw.c
>> +++ b/drivers/media/rc/rc-ir-raw.c
>> @@ -256,7 +256,8 @@ int ir_raw_event_register(struct rc_dev *dev)
>>                 return -ENOMEM;
>>
>>         dev->raw->dev = dev;
>> -       dev->enabled_protocols = ~0;
>> +       /* by default, disable all but lirc*/
>> +       dev->enabled_protocols = RC_BIT_LIRC;
>>         rc = kfifo_alloc(&dev->raw->kfifo,
>>                          sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
>>                          GFP_KERNEL);
