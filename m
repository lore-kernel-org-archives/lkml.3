Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab3C3DCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 23:02:32 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55226 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab3C3DCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 23:02:30 -0400
MIME-Version: 1.0
In-Reply-To: <1364609309.1818.8.camel@buesod1.americas.hpqcorp.net>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	<CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
	<CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
	<CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
	<1364609309.1818.8.camel@buesod1.americas.hpqcorp.net>
Date: Sat, 30 Mar 2013 10:02:29 +0700
Message-ID: <CA+i8gK+LP_4SU8GwLMau0QvyGswZ5sKqOYnJVPZNWXZY_W9dEA@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On Sat, Mar 30, 2013 at 9:08 AM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> Not sure which one liner you refer to, but, if you haven't already done
> so, please try with these fixes (queued in linux-next):
>
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=a9cead0347283f3e72a39e7b76a3cc479b048e51
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=4db64b89525ac357cba754c3120065adddd9ec31
>
> I've been trying to reproduce your twilight zone problem on five
> different machines now without any luck. Is there anything you're doing
> to trigger the issue? Does the machine boot ok and then do weird things,
> say after X starts, open some program, etc?

I was missing a9cead0, thanks. What I usually do is starting a
standard session, which looks like this:

init-+-5*[agetty]
     |-bash---startx---xinit-+-X---2*[{X}]
     |                       `-dwm---sh---sleep
     |-bash---chromium-+-chromium
     |                 |-chromium-+-chromium
     |                 |          `-2*[{chromium}]
     |
|-chromium-sandbo---chromium---chromium---4*[chromium---4*[{chromium}]]
     |                 `-65*[{chromium}]
     |-crond
     |-dbus-daemon
     |-klogd
     |-syslogd
     |-tmux-+-alsamixer
     |      |-bash---bash
     |      |-bash
     |      |-htop
     |      `-newsbeuter---{newsbeuter}
     |-udevd
     |-urxvtd-+-bash---pstree
     |        `-bash---tmux
     `-wpa_supplicant

Then I start building a random package and the problems start. They
may also happen without compiling but this seems to trigger the bug
quite quickly. Anyway, some progress here, I hope: dmesg seems to be
willing to reveal some secrets (using some pastebin service since this
is pretty big):

https://gist.github.com/anonymous/5275120

Thanks.
