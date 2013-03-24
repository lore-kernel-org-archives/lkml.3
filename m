Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3CXNqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 09:46:40 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:41401 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab3CXNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 09:46:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxjGFi+gt3UwdVCVKP5riHSR=_qLkp0SovgW2zx+gcRow@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
	<CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
	<CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
	<CA+55aFxjGFi+gt3UwdVCVKP5riHSR=_qLkp0SovgW2zx+gcRow@mail.gmail.com>
Date: Sun, 24 Mar 2013 20:46:38 +0700
Message-ID: <CA+i8gKJuykoCk=O3qbDmmZXd=8U13wF7o_NzUviccaZoU6WLaA@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 2:45 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 22, 2013 at 8:19 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>>
>> I could reproduce it but could you please let me know what would be
>> the right tools I should use to catch the original oops?
>> This is what I got but I doubt it will be helpful:
>> http://i.imgur.com/Mewi1hC.jpg
>
> In this case, I think the best thing to do would be to comment out all
> of drm_warn_on_modeset_not_all_locked(), because those warnings make
> the original problem (that probably caused the lock problem in the
> first place that it is warning about) scroll away.
>
> That said, you should also take the oneliner fix that Rik posted to
> patch 7 (subject line: "[PATCH 7/7 part3] fix for sem_lock") and apply
> that, just to make sure that you aren't possibly hitting a bug with
> the shared-memory locking introduced by that (unusual) case.

Thanks Linus. I hope I got this right, here's the result (3.9-rc4, 7+1
patches): http://i.imgur.com/BebGZxV.jpg
