Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3IKDW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:22:59 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:65016 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3IKDW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:22:57 -0400
MIME-Version: 1.0
In-Reply-To: <522FCC06.3090907@hp.com>
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
	<CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
	<CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
	<CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
	<CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
	<CAMfhy93EoDohCrV+ykj6b+R9QSCTdiPtvSpJpe3SH=ot_1LWMg@mail.gmail.com>
	<CA+55aFxvAn=jTbQXxery54uaaq=QsLzJgPdwnTd8B77abc92jQ@mail.gmail.com>
	<CAMfhy92u1GFvTrO+8SNp8hoEBEHcd7Z-3mw+79rv8+2yYqa+ow@mail.gmail.com>
	<CAMfhy90vEu2_hfoOnzB+ZOit4HNmKex2WObmztcY7R4+PBwd7w@mail.gmail.com>
	<CA+55aFzFWbCGqaGe1BbuBY_j+0xK-UfYEJddjSWriufs0Q5PmQ@mail.gmail.com>
	<522FCC06.3090907@hp.com>
Date: Tue, 10 Sep 2013 20:22:56 -0700
X-Google-Sender-Auth: weGAlZ8VeNiVMRNueFfsKjJAZJc
Message-ID: <CA+55aFyGEzptqWOL1P+iqqPNOomsbKzHVy1+zBQ3pE21_=KXWA@mail.gmail.com>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Mace Moneta <moneta.mace@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 6:48 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> I need to clean up some comments in the code. The other thing that I want to
> do is to introduce read_seqlock/read_sequnlock() primitives that do the
> locking without incrementing the sequence number.

I don't understand. That's the whole *point* of sequence numbers. The
read-locker doesn't ever change the number, only the write-locker
does.

So I don't see what you would change.

            Linus
