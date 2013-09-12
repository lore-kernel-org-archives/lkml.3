Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab3ILTE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:04:58 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:51764 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab3ILTE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:04:57 -0400
MIME-Version: 1.0
In-Reply-To: <52320FA3.7000908@hp.com>
References: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFwsqHJE1D-z8_kU+1VEpUTB=EU57kqmKao580gYZVOjrw@mail.gmail.com>
	<CA+55aFy8Nq7yf9CJwFuyfSmkUzFKRHHOE6O8=4HjmaWpku3fhw@mail.gmail.com>
	<52320FA3.7000908@hp.com>
Date: Thu, 12 Sep 2013 12:04:56 -0700
X-Google-Sender-Auth: Rh03aR58_Eddg-5R64-2xviqVl8
Message-ID: <CA+55aFyvC=vKWn2-PBrfyFB9gS08DBUNwXvHhO6KaoLz=SJbMw@mail.gmail.com>
Subject: Re: [PATCH 0/2 v2] dcache: get/release read lock in
 read_seqbegin_or_lock() & friend
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 12:01 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> Yes, I think we can do something similar for this. I will take a look to see
> how it can be fixed.

Actually, it was so trivial that I already did it, and only had one
stupid brown-bag moment while doing so.

Now my threaded test-case spends most of its time allocating the
temporary page for the result.

It's pushed out.

Btw, Al, I really want a pull request from you to fix the "returning
to user space with semaphore held" thing. Or I'm going to apply the
patch myself.  I'm on the road starting very early tomorrow morning,
and I don't want to have that hanging over me..

         Linus
