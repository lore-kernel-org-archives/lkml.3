Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3CaCi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 22:38:27 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:37632 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab3CaCiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 22:38:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyqhacFz9xc3igO2mpmwFHdMKGGMVbbrUiOOrkyjVxMXg@mail.gmail.com>
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
	<CA+i8gKKNf2105vi93t=KBs5fVRUcaD6BP5hhYE-8cwy2OBAx8w@mail.gmail.com>
	<CA+55aFyqhacFz9xc3igO2mpmwFHdMKGGMVbbrUiOOrkyjVxMXg@mail.gmail.com>
Date: Sun, 31 Mar 2013 09:38:24 +0700
Message-ID: <CA+i8gKLSBddyPGL6FW63=wB68gmafaF24G3ZL7P+qyTw95nQHQ@mail.gmail.com>
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

Hi Linus,

On Sun, Mar 31, 2013 at 12:22 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 29, 2013 at 10:57 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>> On Sat, Mar 30, 2013 at 12:10 PM, Linus Torvalds
>>>
>>> This came from the gcc build?
>>
>> yes, very early in the build process, IIRC this line was repeated a
>> few times and the build just stalled.
>
> Ok, we're bringing out the crazy hacks now.
>
> The attached patch is just insane, doesn't really even work in
> general, and only even compiles on 64-bit. But it should work in
> *practice* to find if somebody adds the same RCU head to the RCU lists
> twice, and ignore the second time it happens (and give a warning that
> hopefully pinpoints the backtrace).
>
> It's ugly. It's broken. It may not work. In other words, I'm not proud
> of it. But you seem to be the only one able to trigger the issue
> easily, willing to try crazy crap, so "tag, you're it". Maybe this
> gives us more information. And maybe it doesn't, and I'm totally wrong
> about the whole "rcu head added twice" theory.

That's all I could get so far:
https://gist.github.com/anonymous/5279255

Losing wireless is generally the start signal of controlled demolition
of the machine.
