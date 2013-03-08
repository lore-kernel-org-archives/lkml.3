Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab3CHXpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:45:39 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:49308 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3CHXpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:45:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130308233041.GA32587@redhat.com>
References: <20130308150408.GA25399@redhat.com>
	<CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
	<20130308191804.GA9774@redhat.com>
	<20130308192042.GA10305@redhat.com>
	<20130308193652.GA11692@redhat.com>
	<CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
	<20130308210432.GA21500@redhat.com>
	<CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
	<20130308230734.GA28317@redhat.com>
	<CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
	<20130308233041.GA32587@redhat.com>
Date: Fri, 8 Mar 2013 15:45:37 -0800
X-Google-Sender-Auth: 1wjI-LCPO1gQmTMqIS4bwSpogyc
Message-ID: <CA+55aFxBvyLcWJB0JMNcaCXHtgvPLt3cFQqJeRFcb=6rkZFtvA@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 3:30 PM, Dave Jones <davej@redhat.com> wrote:
> [  100.729401] nd->last.name = (\xffffffd2.W._.N.".\xfffffffe.\xffffff80.^N.?.\xffffffe4.E.8.g.\xffffffd2.N.\xffffffb6.^G.\xfffffff1.\xffffffcc.U.\xffffffda.^_.h.^M.1.\xffffffc5.\xffffff82.%.B.\xffffffe0.\xffffffad.^U.8.^L.c.Z.^K.\xffffffe4.h.J.\xffffffc8.\xffffffad.\xffffff83./.\xffffff80.\xffffffd1.\xffffffe5.\xffffff87.\xffffffc3.\xffffffb2.\xffffffdc.\xffffff9d.\xffffffd1.E.\xffffffab.^B.

You're printing out a 'char' with %02x, aren't you? And then the sign
extensions gives you six extra 'f' character every time the char is
negative.

If using %02x, make sure you use 'unsigned char', or "& 255".

Depending on just what is going on, the "nd->last.name" thing really
is probably a valid string. Strictly speaking it's not necessarily
NUL-terminated, though, and should be printed out to a maximum of
"nd->last.len" characters (but the whole path will be NUL-terminated,
so it's all ok, you just might print out more than one component)

               Linus
