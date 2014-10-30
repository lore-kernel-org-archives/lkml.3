Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbaJ3MDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:03:54 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64794 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180AbaJ3MDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:03:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Mack <daniel@zonque.org>
Cc: Tom Gundersen <teg@jklm.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>,
        Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        "alban.crequy" <alban.crequy@collabora.co.uk>,
        "javier.martinez" <javier.martinez@collabora.co.uk>
Subject: Re: kdbus: add header file
Date: Thu, 30 Oct 2014 13:03:44 +0100
Message-ID: <3334170.rJW8YMf1Nv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5452269A.9050003@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <6078917.F7Y7rNpK9C@wuerfel> <5452269A.9050003@zonque.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TOdJbJCR1XZ6rkVsVX6fboajlsn4eI2D8pcEbyUhtmM
 X+t8sRtZcYupwhszkPNMdrxvjRx60aYtlLED3Jj/fTMxHKMOYa
 kU348GHp1PQIdXT0jSMX7nMS0r0awMRqKK6ZFTsqBcEFA6CmrI
 Aj64hsGI+ZUTErv+putBXPNRMIAFKM0YAaeIo4JthPw10JqjxE
 uX2WrDjOYIcxs2FyMvD8FiKXHqVEQqvAfxmXFU4GwzqELKrYoq
 n1ea7Onr5y+CLeGbCsNVrFs6APfLLm9RVENcd7BlBjhsA+Wf//
 yZDx37bzNReawL00kqxH2z1U9wHZzFDANhHXPzl7e/Wr0XZ3EE
 aCdGW659ZVZnHdMAwuYY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 12:52:58 Daniel Mack wrote:
> On 10/30/2014 12:26 PM, Arnd Bergmann wrote:
> > On Thursday 30 October 2014 12:02:39 Tom Gundersen wrote:
> 
> >> The nice thing about enums is of course that it helps with debugging
> >> as gdb can show the string representation rather than the number,
> >> because in contrast to #defines, an enum is something the compliler
> >> knows about.
> > 
> > This doesn't get passed as an enum in user space though, and when debugging
> > the kernel it only helps within one function.
> 
> Hmm, this is the header exported to userspace, so having enums in would
> make our lives easier, right?

My point was that you never use the enum by type and the only place in
user space where it's referenced would be something like

	ret = ioctl(fd, KDBUS_CMD_BUS_MAKE, &make);

In the debugger, you will see the source line here. If you trace into the
glibc ioctl function, you no longer know the type because that just
has an 'int'.

> Hence, for now, I'd propose we keep it the way it is, and add new ioctls
> with defines once they are implemented. Are you okay with this? I'll add
> a comment to the file to give a heads-up.

It's certainly not a show-stopped, but I have yet to see a good reason
why it would help anyone.

	Arnd
