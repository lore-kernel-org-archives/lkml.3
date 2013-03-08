Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab3CHXap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:30:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab3CHXao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:30:44 -0500
Date: Fri, 8 Mar 2013 18:30:41 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130308233041.GA32587@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 03:20:40PM -0800, Linus Torvalds wrote:
 > On Fri, Mar 8, 2013 at 3:07 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > Ok, got something more meaningful out of the lookup_slow trace.
 > >
 > > [   66.082984] parent->dname.name  (06b6b6b6b6b6b6b)
 > > [   66.083637] parent =
 > >
 > > At first I thought AH-HA! SLAB POISON!
 > > But look closer.. it's shifted by 8 bits.
 > 
 > Or just the high byte has been cleared.

Duh, yes. I wasn't zero padding, so that's 006b6b6b.

Here's another run, with something similar in path->dentry..

[  100.729395] parent->dname.name  (06 b6 b6b 6b6b6b6b 6b6b6b6b 6b6b6b6b)
[  100.729397] path->dentry: 6d6e740 6b6b6b6b
[  100.729401] nd->last.name = (\xffffffd2.W._.N.".\xfffffffe.\xffffff80.^N.?.\xffffffe4.E.8.g.\xffffffd2.N.\xffffffb6.^G.\xfffffff1.\xffffffcc.U.\xffffffda.^_.h.^M.1.\xffffffc5.\xffffff82.%.B.\xffffffe0.\xffffffad.^U.8.^L.c.Z.^K.\xffffffe4.h.J.\xffffffc8.\xffffffad.\xffffff83./.\xffffff80.\xffffffd1.\xffffffe5.\xffffff87.\xffffffc3.\xffffffb2.\xffffffdc.\xffffff9d.\xffffffd1.E.\xffffffab.^B.
(garbage continues..)

