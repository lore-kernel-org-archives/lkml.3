Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaLaAWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 19:22:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaLaAWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 19:22:00 -0500
Message-ID: <1419985309.5162.79.camel@localhost>
Subject: Re: fanotify bug on gdb -- hard crash
From: Eric Paris <eparis@redhat.com>
To: ivo welch <ivo.welch@gmail.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-kernel@vger.kernel.org
Date: Tue, 30 Dec 2014 19:21:49 -0500
In-Reply-To: <CAPr7RtVSojwe5Q9k=EE6SSUAE1a46beqOV0TCZbkfhvrADQEGg@mail.gmail.com>
References: <CAPr7RtWpX_kYiJRRnPVSZrL-U2GqoV5aBPM_AF7xBzV99jzJuw@mail.gmail.com>
	 <549DAB95.3090003@gmx.de> <1419808412.5162.73.camel@localhost>
	 <CAPr7RtWQ6bt4M8f-2-w0nbLvgpupb0kckE=VQDYbC8EXwiPDJg@mail.gmail.com>
	 <1419827352.5162.77.camel@localhost>
	 <CAPr7RtVSojwe5Q9k=EE6SSUAE1a46beqOV0TCZbkfhvrADQEGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-29 at 13:06 +0800, ivo welch wrote:
> thank you, eric.  will do.  I read up on it above and now understand it better.

Great let us know if it keeps giving you trouble!

> the example in the man page seems somewhat misfortunate.  I would use
> an example that does not, by default, lock up the user system.
> (perhaps add a second example with the _PERM feature that shows how it
> responds.)

The link you gave does respond and allow permissions:

               if (metadata->fd >= 0) {

                       /* Handle open permission event */

                       if (metadata->mask & FAN_OPEN_PERM) {
                           printf("FAN_OPEN_PERM: ");

                           /* Allow file to be opened */

                           response.fd = metadata->fd;
                           response.response = FAN_ALLOW;
                           write(fd, &response,
                                 sizeof(struct fanotify_response));
                       }

That's the key bit of the example...  If you use gdb and never get to
there, you are in a bit of trouble, I agree!

