Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaJBQKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:10:45 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:41967 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaJBQKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <542D6981.3080405@oracle.com>
References: <20140930033327.GA14558@redhat.com>
	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
	<20140930043309.GA16196@redhat.com>
	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
	<20140930160510.GA15903@redhat.com>
	<CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
	<20140930162201.GC15903@redhat.com>
	<20140930164047.GA18354@redhat.com>
	<CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
	<20140930182059.GA24431@redhat.com>
	<CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
	<alpine.LSU.2.11.1410010031070.1902@eggly.anvils>
	<CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
	<CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>
	<CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>
	<542C7B5E.2020000@oracle.com>
	<CA+55aFy7Y+pmhyEHTJg=K8gLKzLHxzz6j9FBJMt7_Fazfong6g@mail.gmail.com>
	<542D6981.3080405@oracle.com>
Date: Thu, 2 Oct 2014 09:10:42 -0700
X-Google-Sender-Auth: oX8oTIb5Eczz4sCMOUrAWKq8yPU
Message-ID: <CA+55aFx_Q7C2a9yCAqK=yWNX1mkcVRdE2bnLOQPHEkMjRcj7KQ@mail.gmail.com>
Subject: Re: pipe/page fault oddness.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 8:04 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I have a new one for you. I know it doesn't say "numa" anywhere, but I
> haven't ever seen that trace before so I'll just go ahead and blame it
> on your patch...

Fair enough, but the oops doesn't really give even a hint of what
could be wrong.

The stack is clearly too deep:

  Thread overran stack, or stack corrupted
  task.ti: ffff880dba2ec000
    RSP: ffff880dba2ebf48

but my patch shouldn't have added any deeper call-chains anywhere.

Anyway, unless you can get some other interesting oops with more hints
about where we go wrong, you might want to try Mel's four cleanup
patches instead. I love how you're testing my quick-and-dirty hack,
and I think we'll need to do this eventually, but in the short term
Mel's patches are probably worth applying.

In particular, his 4/4 patch removes the code case that I was
particularly nervous about, so it looks worth a try, because that may
just remove the bug with much smaller effort.

               Linus
