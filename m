Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaKLAgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:36:09 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59501 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaKLAgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:36:07 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz1oxCgZiY4oWu41fFUbKft9g5_gQXXzAKuW8+pnR72Vw@mail.gmail.com>
References: <1415360716-9670-2-git-send-email-borntraeger@de.ibm.com>
	<54611D86.4040306@de.ibm.com>
	<CA+55aFyEigSL64RJH8AO86gFBBB84+dgk7eEUPx=CaLwJMcO_w@mail.gmail.com>
	<54627CBF.2000704@de.ibm.com>
	<CA+55aFz1oxCgZiY4oWu41fFUbKft9g5_gQXXzAKuW8+pnR72Vw@mail.gmail.com>
Date: Tue, 11 Nov 2014 16:36:06 -0800
X-Google-Sender-Auth: JxBXknOavMlie-6kXlXKJgvV30I
Message-ID: <CA+55aFw+cLJ6xW0Wk6nMbK+e1yr2KGCWN+-v2a7xK1u8zTtDtA@mail.gmail.com>
Subject: Re: compiler bug gcc4.6/4.7 with ACCESS_ONCE and workarounds
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Krebbel <Andreas.Krebbel@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 4:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I guess as a workaround it is fine, as long as we don't lose sight of
> trying to eventually do a better job.

Oh, and when it comes to the actual gcc bug - do you have any reason
to believe that it's somehow triggered more easily by something
particular in the arch/s390/kvm/gaccess.c code?

IOW, why does this problem not hit the x86 spinlocks that also use
volatile pointers to aggregate types? Or does it?

                       Linus
