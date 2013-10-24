Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3JXQAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:00:25 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49783 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3JXQAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:00:22 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Large pastes into readline enabled programs causes breakage from v2.6.31 onwards
Date: Thu, 24 Oct 2013 18:00:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.12.0-rc6-00275-g320437af; KDE/4.11.1; x86_64; ; )
Cc: Margarita Manterola <margamanterola@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Maximiliano Curia <maxy@debian.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, bug-readline@gnu.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com> <CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com> <201309030717.57866.a.miskiewicz@gmail.com>
In-Reply-To: <201309030717.57866.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201310241800.18490.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 of September 2013, Arkadiusz Miskiewicz wrote:
> On Sunday 18 of August 2013, Margarita Manterola wrote:
> > Hi,
> > 
> > On Sat, Aug 17, 2013 at 5:28 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > >> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> > >> index 4bf0fc0..2ba7f4e 100644
> > >> --- a/drivers/tty/n_tty.c
> > >> +++ b/drivers/tty/n_tty.c
> > >> @@ -149,7 +149,8 @@ static int set_room(struct tty_struct *tty)
> > >> 
> > >>          * characters will be beeped.
> > >>          */
> > >>         
> > >>         if (left <= 0)
> > >> 
> > >> -               left = ldata->icanon && !ldata->canon_data;
> > >> +               if (waitqueue_active(&tty->read_wait))
> > >> +                       left = ldata->icanon && !ldata->canon_data;
> > >> 
> > >>         old_left = tty->receive_room;
> > >>         tty->receive_room = left;
> > > 
> > > Was this applied? You may want to cc rjw... it is a regression, it is
> > > not pretty, and it is something I blieve I hit but thought it was some
> > > kind of "X weirdness".
> > 
> > There were no replies to the previous mail asking for comments, and as
> > far as I can see this has not been applied. I don't know who rjw is,
> > could you be a bit more explicit, please?
> 

Hi

Was just going over bug-readline and lkml archives and found no continuation 
of this. 

There was a patch proposed but didn't get applied. 
https://lkml.org/lkml/2013/8/17/31
Maybe it only needs proper patch submission?

Looking from bug-readline archives debugging it took huge amount of work and 
would be sad that all that ended up being wasted.

Whole thread if someone lost it https://lkml.org/lkml/2013/7/25/205

-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
