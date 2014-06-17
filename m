Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965636AbaFQQg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:36:59 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53061 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964788AbaFQQg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:36:56 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVpZ0vFM4usHK+tQhk234Y2jWzB1522kGcGvdQQFAqsZQ@mail.gmail.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
	<CALCETrVoE+JO2rLsBUHAOJdvescEEjxikj8iQ339Nxfopfc7pw@mail.gmail.com>
	<CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA@mail.gmail.com>
	<CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com>
	<CANq1E4QQUKHabheq18AzkVZk3WDtAeC-6W66tVNB+EKgYOx1Vg@mail.gmail.com>
	<53A01049.6020502@redhat.com>
	<CANq1E4T3KJZ++=KF2OZ_dd+NvPqg+=4Pw6O7Po3-ZxaaMHPukw@mail.gmail.com>
	<CALCETrVpZ0vFM4usHK+tQhk234Y2jWzB1522kGcGvdQQFAqsZQ@mail.gmail.com>
Date: Tue, 17 Jun 2014 18:36:55 +0200
Message-ID: <CANq1E4QdGz6cRm2Y-vMQHV1O=VK74XNP8qCAmiAskVaVKpJuxg@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Greg KH <greg@kroah.com>,
        Florian Weimer <fweimer@redhat.com>, Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Kay Sievers <kay@vrfy.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Mack <zonque@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tony Battersby <tonyb@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Jun 17, 2014 at 6:20 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Can you summarize why holes can't be reliably backed by the zero page?

To answer this, I will quote Hugh from "PATCH v2 1/3":

> We do already use the ZERO_PAGE instead of allocating when it's a
> simple read; and on the face of it, we could extend that to mmap
> once the file is sealed.  But I am rather afraid to do so - for
> many years there was an mmap /dev/zero case which did that, but
> it was an easily forgotten case which caught us out at least
> once, so I'm reluctant to reintroduce it now for sealing.
>
> Anyway, I don't expect you to resolve the issue of sealed holes:
> that's very much my territory, to give you support on.

Holes can be avoided with a simple fallocate(). I don't understand why
I should make SEAL_WRITE do the fallocate for the caller. During the
discussion of memfd_create() I was told to drop the "size" parameter,
because it is redundant. I don't see how this implicit fallocate()
does not fall into the same category?

Thanks
David
