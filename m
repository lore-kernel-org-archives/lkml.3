Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3IKEMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:12:41 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54755 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3IKEMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130911035636.GI13318@ZenIV.linux.org.uk>
References: <CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
	<CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
	<CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
	<CAMfhy93EoDohCrV+ykj6b+R9QSCTdiPtvSpJpe3SH=ot_1LWMg@mail.gmail.com>
	<CA+55aFxvAn=jTbQXxery54uaaq=QsLzJgPdwnTd8B77abc92jQ@mail.gmail.com>
	<CAMfhy92u1GFvTrO+8SNp8hoEBEHcd7Z-3mw+79rv8+2yYqa+ow@mail.gmail.com>
	<CAMfhy90vEu2_hfoOnzB+ZOit4HNmKex2WObmztcY7R4+PBwd7w@mail.gmail.com>
	<CA+55aFzFWbCGqaGe1BbuBY_j+0xK-UfYEJddjSWriufs0Q5PmQ@mail.gmail.com>
	<522FCC06.3090907@hp.com>
	<CA+55aFyGEzptqWOL1P+iqqPNOomsbKzHVy1+zBQ3pE21_=KXWA@mail.gmail.com>
	<20130911035636.GI13318@ZenIV.linux.org.uk>
Date: Tue, 10 Sep 2013 21:12:39 -0700
X-Google-Sender-Auth: SW9xhAAYzA8xIWEBMXxuXBFBJOA
Message-ID: <CA+55aFw=Yegyn9TSESWmvw8GqcaorOMuGCUnCmdP=k2yeXzMPA@mail.gmail.com>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <waiman.long@hp.com>, Mace Moneta <moneta.mace@gmail.com>,
        Josh Boyer <jwboyer@gmail.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 8:56 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I do.  What we need on the second pass (one where we currently
> take seq_writelock()) is exclusion against writers; nothing we are
> doing is worth disturbing the readers - we don't change any data
> structures.  And simple grabbing the spinlock, without touching the
> sequence number would achieve exactly that.  Writers will have to
> wait and won't be able to disturb us, readers won't notice anything
> happening.  So yes, this extra primitive does make sense here.

Ahh. Yes, as a fallback from the reader-side sequence lock that makes
perfect sense..

              Linus
