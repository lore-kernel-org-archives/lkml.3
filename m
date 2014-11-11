Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaKKAX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 19:23:59 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45230 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaKKAX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 19:23:57 -0500
MIME-Version: 1.0
Date: Mon, 10 Nov 2014 16:23:57 -0800
Message-ID: <CAD=GYpYqbTrJ-wTZy=UBX1Z5=zMGVoaYU8jSa81rrcC4G0271w@mail.gmail.com>
Subject: Confusion about __do_fault and MM_ANONPAGES
From: Joel Fernandes <agnel.joel@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have some confusion about when is anon=1 when __do_fault is called.

__do_fault seems to be called only when the page fault is of a linear
or a non-linear mapping. My understanding is neither of these can be
anonymous, so I am confused about the below code fragment:

In which case is anon=1 when memory.c::__do_fault is called?
In __do_fault, you'll see something like...
        if (anon) {
            inc_mm_counter_fast(mm, MM_ANONPAGES);
            page_add_new_anon_rmap(page, vma, address);
        } else {


Thanks!
Joel
