Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3J2OsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:48:07 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48457 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846Ab3J2OsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:48:05 -0400
MIME-Version: 1.0
In-Reply-To: <1383037384-30079-1-git-send-email-geert@linux-m68k.org>
References: <1383037384-30079-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 29 Oct 2013 15:48:04 +0100
X-Google-Sender-Auth: obJ4m0XeCTMw3R7V9rAMGpCtJcM
Message-ID: <CAMuHMdVcq8pefMwxZFNMmSb2kkfVOLxTX1WM=F0ixJZT98NTkg@mail.gmail.com>
Subject: Re: [PATCH RFC] mfd: Stop setting refcounting pointers in original
 mfd_cell arrays
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andres Salomon <dilinger@queued.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:03 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Note that there's another issue in mfd_add_devices(): if the first call to
> mfd_add_device() fails, the array of atomic_t objects will never be freed,
> as no child devices have been registered to the parent yet, and thus
> mfd_remove_devices() won't find anything to remove nor free.

This was actually not that difficult to fix, so I've just sent out a patch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
