Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3HQW5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 18:57:51 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38936 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3HQW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 18:57:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130817152853.GA24838@amd.pavel.ucw.cz>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
	<51F1B015.50804@hurleysoftware.com>
	<20130730124117.41DC55E4006@freak.gnuservers.com.ar>
	<51F7E4ED.4050409@hurleysoftware.com>
	<20130808175839.GB21618@gnuservers.com.ar>
	<20130817152853.GA24838@amd.pavel.ucw.cz>
Date: Sun, 18 Aug 2013 00:57:50 +0200
Message-ID: <CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
From: Margarita Manterola <margamanterola@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Maximiliano Curia <maxy@debian.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Aug 17, 2013 at 5:28 PM, Pavel Machek <pavel@ucw.cz> wrote:

>> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
>> index 4bf0fc0..2ba7f4e 100644
>> --- a/drivers/tty/n_tty.c
>> +++ b/drivers/tty/n_tty.c
>> @@ -149,7 +149,8 @@ static int set_room(struct tty_struct *tty)
>>          * characters will be beeped.
>>          */
>>         if (left <= 0)
>> -               left = ldata->icanon && !ldata->canon_data;
>> +               if (waitqueue_active(&tty->read_wait))
>> +                       left = ldata->icanon && !ldata->canon_data;
>>         old_left = tty->receive_room;
>>         tty->receive_room = left;

> Was this applied? You may want to cc rjw... it is a regression, it is
> not pretty, and it is something I blieve I hit but thought it was some
> kind of "X weirdness".

There were no replies to the previous mail asking for comments, and as
far as I can see this has not been applied. I don't know who rjw is,
could you be a bit more explicit, please?

-- 
Besos,
Marga
