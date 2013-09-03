Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab3ICFSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:18:08 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50104 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343Ab3ICFSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:18:01 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Large pastes into readline enabled programs causes breakage from v2.6.31 onwards
Date: Tue, 3 Sep 2013 07:17:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.7-dirty; KDE/4.11.0; x86_64; ; )
Cc: Margarita Manterola <margamanterola@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Maximiliano Curia <maxy@debian.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com> <20130817152853.GA24838@amd.pavel.ucw.cz> <CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com>
In-Reply-To: <CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201309030717.57866.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 of August 2013, Margarita Manterola wrote:
> Hi,
> 
> On Sat, Aug 17, 2013 at 5:28 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> >> index 4bf0fc0..2ba7f4e 100644
> >> --- a/drivers/tty/n_tty.c
> >> +++ b/drivers/tty/n_tty.c
> >> @@ -149,7 +149,8 @@ static int set_room(struct tty_struct *tty)
> >> 
> >>          * characters will be beeped.
> >>          */
> >>         
> >>         if (left <= 0)
> >> 
> >> -               left = ldata->icanon && !ldata->canon_data;
> >> +               if (waitqueue_active(&tty->read_wait))
> >> +                       left = ldata->icanon && !ldata->canon_data;
> >> 
> >>         old_left = tty->receive_room;
> >>         tty->receive_room = left;
> > 
> > Was this applied? You may want to cc rjw... it is a regression, it is
> > not pretty, and it is something I blieve I hit but thought it was some
> > kind of "X weirdness".
> 
> There were no replies to the previous mail asking for comments, and as
> far as I can see this has not been applied. I don't know who rjw is,
> could you be a bit more explicit, please?

Hi.

Was there some kind of continuation of this thread or the thing died 
completly?

-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
