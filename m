Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaDKVb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:31:29 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57532 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaDKVb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:31:27 -0400
MIME-Version: 1.0
In-Reply-To: <5347F188.10408@cybernetics.com>
References: <53470E26.2030306@cybernetics.com>
	<CANq1E4RWf_VbzF+dPYhzHKJvnrh86me5KajmaaB1u9f9FLzftA@mail.gmail.com>
	<5347451C.4060106@amacapital.net>
	<5347F188.10408@cybernetics.com>
Date: Fri, 11 Apr 2014 23:31:27 +0200
Message-ID: <CANq1E4T=38VLezGH2XUZ9kc=Vtp6Ca++-ATwmEfaXZS6UrTPig@mail.gmail.com>
Subject: Re: [PATCH 2/6] shm: add sealing API
From: David Herrmann <dh.herrmann@gmail.com>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Apr 11, 2014 at 3:43 PM, Tony Battersby <tonyb@cybernetics.com> wrote:
> Exactly.  For O_DIRECT, that would be the call to get_user_pages_fast()
> from dio_refill_pages() in fs/direct-io.c, which is ultimately called
> from blkdev_direct_IO().

If you drop mmap_sem after pinning a page without taking a write-ref,
you break i_mmap_writable / VM_DENYWRITE. In memfd I rely on
i_mmap_writable to work, same thing is done by exec() (and the old,
now disabled, MAP_DENYWRITE).

I don't know whether I should care. I mean, everyone pinning pages and
writing to it without holding the mmap_sem has to take a write-ref for
each page or it breaks i_mmap_writable. So this seems to be a bug in
direct-IO, not in anyone relying on it, right?

Thanks
David
