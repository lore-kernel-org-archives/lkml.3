Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3C3F6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 01:58:01 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:35944 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3C3F57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 01:57:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy7OtkWiqO+CxmDgkyfR_58=hdkc-VoaqWCngETw19Euw@mail.gmail.com>
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
	<CA+i8gK+LP_4SU8GwLMau0QvyGswZ5sKqOYnJVPZNWXZY_W9dEA@mail.gmail.com>
	<CA+55aFzqzHa_6bHrqaa+6k3PZiibuJuDd1VwVD7jL047BjR=hA@mail.gmail.com>
	<CA+i8gKL3PCBW_KxkYSOKE7-PHdHVsP6eLUBTuYRtunBheALJMg@mail.gmail.com>
	<CA+55aFy7OtkWiqO+CxmDgkyfR_58=hdkc-VoaqWCngETw19Euw@mail.gmail.com>
Date: Sat, 30 Mar 2013 12:57:58 +0700
Message-ID: <CA+i8gKKNf2105vi93t=KBs5fVRUcaD6BP5hhYE-8cwy2OBAx8w@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Dave Jones <davej@redhat.com>,
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

On Sat, Mar 30, 2013 at 12:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> Another shot in
>> the dark, I had this weird message when trying to build gcc:
>> semop(2): encountered an error: Identifier removed
>
> This came from the gcc build?

yes, very early in the build process, IIRC this line was repeated a
few times and the build just stalled.

> That's just crazy. No normal app uses sysv semaphores. I have an older
> gcc build environment, and some grepping shows it has some ipc
> semaphore use in the libstdc++ testsuite, and some libmudflap hooks,
> but that should be very very minor.

> I notice that your dmesg says that your kernel is compiled by
> gcc-4.8.1 prerelease. Is there any chance that you could try to
> install a known-stable gcc, like 4.7.2 or something. It's entirely
> possible that it's a kernel bug even if it's triggered by some more
> aggressive compiler optimization or something, but it would be really
> good to try to see if this might be gcc-specific.

I could build a kernel on another machine on which 4.7.2 is installed,
kernel oops'd as well:
http://i.imgur.com/uk6gmq1.jpg

FWIW, I have a few things disabled in my config so here is the one I
used, maybe I'm missing something (but again, everything works
perfectly with your tree):
https://gist.github.com/anonymous/5275566

Lastly, just FTR, I tried Andrew's 3.9-rc4-mm1 and got the same
issues, unsurprisingly I guess.
