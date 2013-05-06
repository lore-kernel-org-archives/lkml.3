Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3EFTCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:02:48 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:48327 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3EFTCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:02:47 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbKhoNWRAHE93VNW9zNMerBpmbSuHfvhrR_JJcSRvqN6Vg@mail.gmail.com>
References: <CA+8MBb++1CVLAo3zw4fx2O7akWsZcvybRyZpt0ac0sX7M=u5Xw@mail.gmail.com>
	<5187F9F5.7090501@fisher-privat.net>
	<CA+8MBbKhoNWRAHE93VNW9zNMerBpmbSuHfvhrR_JJcSRvqN6Vg@mail.gmail.com>
Date: Mon, 6 May 2013 12:02:46 -0700
Message-ID: <CA+8MBb+W=HbTdkcJ9FbVOkvNCfqGDSzktR_7GrpvmhJ2t9D1Qw@mail.gmail.com>
Subject: Re: VFAT complains that my file system may be corrupted
From: Tony Luck <tony.luck@gmail.com>
To: Oleksij Rempel <bug-track@fisher-privat.net>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 11:51 AM, Tony Luck <tony.luck@gmail.com> wrote:
> I guess I can fake them easily (ia64 runs little endian on Linux).

Duh. Especially as the only use is line 560-562 in src/boot.c:

      de.starthi = CT_LE_W(0);
      de.start = CT_LE_W(0);
      de.size = CT_LE_L(0);

Gotta make sure to use a little endian 0 rather than risk a big-endian one. WTF?

Anyhow ... thanks for the pointer. That fixed my filesystem for me.

-Tony
