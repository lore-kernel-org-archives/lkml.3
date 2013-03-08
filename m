Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3CHWlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:41:21 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:41343 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3CHWlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:41:20 -0500
MIME-Version: 1.0
In-Reply-To: <20130308210432.GA21500@redhat.com>
References: <20130307021645.GA10173@redhat.com>
	<20130308150408.GA25399@redhat.com>
	<CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
	<20130308191804.GA9774@redhat.com>
	<20130308192042.GA10305@redhat.com>
	<20130308193652.GA11692@redhat.com>
	<CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
	<20130308210432.GA21500@redhat.com>
Date: Fri, 8 Mar 2013 14:41:19 -0800
X-Google-Sender-Auth: TDKTcI8gN5H8U2bX7oXFLnKdIHs
Message-ID: <CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 1:04 PM, Dave Jones <davej@redhat.com> wrote:
>
> queue up the sad trombone noises.
>
> One of the things trinity passes syscalls is a page of deformed unicode.
> Apparently this page is so fucked up, that it crashes *printk*.

It's probably my debug stuff that is bogus. One of the string pointers
passed to printk %s seems bad, and instead of being a proper kernel
pointer it's "0xaf0f48ef7bdef7bd". So trying to access it causes a GP
fault (it's not a validly formed pointer)

I'm not seeing what the problem is, but I'll mull on it..

              Linus
