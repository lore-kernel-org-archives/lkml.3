Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaCTDtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:49:31 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:48656 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaCTDt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
Date: Wed, 19 Mar 2014 20:49:28 -0700
X-Google-Sender-Auth: mn5R-q5nhPb4KEvafu9hWQIhnpg
Message-ID: <CA+55aFyNORiS2XidhWoDBVyO6foZuPJTg_BOP3aLtvVhY1R6mw@mail.gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        =?UTF-8?Q?Kristian_H=C3=B8gsberg?= <krh@bitplanet.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 12:06 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
>
> Unlike existing techniques that provide similar protection, sealing allows
> file-sharing without any trust-relationship. This is enforced by rejecting seal
> modifications if you don't own an exclusive reference to the given file.

I like the concept, but I really hate that "exclusive reference"
approach. I see why you did it, but I also worry that it means that
people can open random shm files that are *not* expected to be sealed,
and screw up applications that don't expect it.

Is there really any use-case where the sealer isn't also the same
thing that *created* the file in the first place? Because I would be a
ton happier with the notion that you can only seal things that you
yourself created. At that point, the exclusive reference isn't such a
big deal any more, but more importantly, you can't play random
denial-of-service games on files that aren't really yours.

The fact that you bring up the races involved with the exclusive
reference approach also just makes me go "Is that really the correct
security model"?

                   Linus
