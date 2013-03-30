Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3C3CIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 22:08:35 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44836 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab3C3CId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 22:08:33 -0400
Message-ID: <1364609309.1818.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Emmanuel Benisty <benisty.e@gmail.com>
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
Date: Fri, 29 Mar 2013 19:08:29 -0700
In-Reply-To: <CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	 <20130326192852.GA25899@redhat.com>
	 <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	 <20130329161746.GA8391@redhat.com>
	 <CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	 <CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
	 <CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
	 <CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-30 at 08:36 +0700, Emmanuel Benisty wrote:
> Hi Linus,
> 
> On Sat, Mar 30, 2013 at 6:16 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Emmanuel, can you try the attached patch? I think it applies cleanly
> > on top of the scalability series too without any changes, but I didn't
> > check if the patches perhaps changed some of the naming or something.
> 
> I had to slightly modify the patch since it wouldn't match the changes
> introduced by 7-7-ipc-sem-fine-grained-locking-for-semtimedop.patch,
> hope that was the right thing to do. So, what I tried was: original 7
> patches + the one liner + your patch blindly modified by me on the top
> of 3.9-rc4 and I'm still having twilight zone issues.

Not sure which one liner you refer to, but, if you haven't already done
so, please try with these fixes (queued in linux-next):

http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=a9cead0347283f3e72a39e7b76a3cc479b048e51
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=4db64b89525ac357cba754c3120065adddd9ec31

I've been trying to reproduce your twilight zone problem on five
different machines now without any luck. Is there anything you're doing
to trigger the issue? Does the machine boot ok and then do weird things,
say after X starts, open some program, etc?

Thanks,
Davidlohr

