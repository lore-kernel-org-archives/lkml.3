Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbbAEVLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:11:22 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:44758 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbbAEVLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:11:20 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwTxbVSGg6F75X2Tt8pYEbV+jVVLOS8AoSqRrcYGELEGQ@mail.gmail.com>
References: <CANd1uZkn_Dk+s9vjxaA4B2oqWVoohzCQOHUuAdt3QK1ng37x6Q@mail.gmail.com>
	<CA+55aFwTxbVSGg6F75X2Tt8pYEbV+jVVLOS8AoSqRrcYGELEGQ@mail.gmail.com>
Date: Mon, 5 Jan 2015 13:11:20 -0800
X-Google-Sender-Auth: KJtNK4WLVIvlnHwDepTtMUKZaDc
Message-ID: <CA+55aFyDM2vV-_zax3-8mhDzsThXs6RAKp_ipHbNHaL0CcsiSw@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jay Foad <jay.foad@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 1:03 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Yup, your analysis sounds correct.  My completely untested gut feel is
> that the problem is that we don't actually return the error from the
> expand_stack() call, so then do_anonymous_page() will allow the extra
> guard-page access.
>
> IOW, *maybe* a patch like this. TOTALLY UNTESTED! I may have missed
> something, and this may be complete crap.

.. and ti's still untested, but I'm pretty sure it's right - except we
should probably also allow an extra page for the stack rlimit (so that
the guard page doesn't count towards the limit).

                          Linus
