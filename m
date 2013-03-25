Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3CYNrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:47:46 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:33676 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818Ab3CYNrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:47:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwb9v9cUG4Ton3faO6xAD18JxxoTPcObXDV_5Zf3QQ=Kw@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
	<CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
	<CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
	<CA+55aFxjGFi+gt3UwdVCVKP5riHSR=_qLkp0SovgW2zx+gcRow@mail.gmail.com>
	<CA+i8gKJuykoCk=O3qbDmmZXd=8U13wF7o_NzUviccaZoU6WLaA@mail.gmail.com>
	<CA+55aFwb9v9cUG4Ton3faO6xAD18JxxoTPcObXDV_5Zf3QQ=Kw@mail.gmail.com>
Date: Mon, 25 Mar 2013 20:47:42 +0700
Message-ID: <CA+i8gK+DNOk5tvRsVJFKyk0A2qOD_az7yJ5+3Y2xS=Ear1VkVA@mail.gmail.com>
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

On Mon, Mar 25, 2013 at 12:10 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> And you never see this problem without Rik's patches?

No, never.

> Could you bisect
> *which* patch it starts with? Are the first four ones ok (the moving
> of the locking around, but without the fine-grained ones), for
> example?

With the first four patches only, I got some X server freeze (just tried once).

> Another thing to try might be to enable SLUB debugging (ie make sure that all of
>
>   CONFIG_SLUB_DEBUG=y
>   CONFIG_SLUB=y
>   CONFIG_SLUB_DEBUG_ON=y
>
> are set in your kernel config)

My bad, I forgot to enable this in my former build, sorry. Here's what
I get now:
http://i.imgur.com/G6H8KgD.jpg
