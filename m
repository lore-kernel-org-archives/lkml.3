Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbaJ3L1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:27:15 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51496 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538AbaJ3L1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:27:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tom Gundersen <teg@jklm.no>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>,
        Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        Daniel Mack <daniel@zonque.org>,
        "alban.crequy" <alban.crequy@collabora.co.uk>,
        "javier.martinez" <javier.martinez@collabora.co.uk>
Subject: Re: kdbus: add header file
Date: Thu, 30 Oct 2014 12:26:58 +0100
Message-ID: <6078917.F7Y7rNpK9C@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAG-2HqV_mXyARMs=9GOpbCBHPU+2XMkDcm=sGekYnnujNPAYqQ@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <3546486.lOZcZMmXYe@wuerfel> <CAG-2HqV_mXyARMs=9GOpbCBHPU+2XMkDcm=sGekYnnujNPAYqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Osmef+fr0oRUwxpMxDoqv0Y/Wf9uLkdMjyF3/WwlJPz
 kvf8cQch6oVPyYXrDupXAz7t4mQX7Z0zYL0i9M1fPazkbhqD16
 MJOwd76Cy6am2vdAa/ziRu4k3OlzdzNOFAtsEBArZgwP/dHgql
 L+ZDRY7FutYBULqdxUhsfYwm4zccilGxiFae2INIe/MRhK/Ckm
 gpRRcUrTIRBvfyC8IVEbYpeANQ8K4O1JFUPCYLw1TCrHSHWsST
 tMiqwoUT9lNzwWCo2NPKIPYX5E60lxw0CjCl36lL8QPtpEpVIC
 vG1PIcOTGLiT1WI0msJ85e9L6WDHswVrcEkYVXynYQzfVOq0ZV
 ob9aBatyOuoHbHVW5eCs=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 12:02:39 Tom Gundersen wrote:
> On Thu, Oct 30, 2014 at 9:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > I think in general, using enum is great, but for ioctl command numbers,
> > we probably want to have defines so the user space implementation can
> > use #ifdef to see if the kernel version that it is being built for
> > knows a particular command.
> 
> Does that make sense for the first version? I agree that we should use
>  #define to allow #ifdef for when we add more ioctls in the future,
> but these ioctls will always exist...

It's mainly for consistency really.

> The nice thing about enums is of course that it helps with debugging
> as gdb can show the string representation rather than the number,
> because in contrast to #defines, an enum is something the compliler
> knows about.

This doesn't get passed as an enum in user space though, and when debugging
the kernel it only helps within one function.

	Arnd
