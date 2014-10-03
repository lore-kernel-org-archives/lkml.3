Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaJCPoC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:44:02 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:53414 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaJCPn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:43:58 -0400
MIME-Version: 1.0
In-Reply-To: <542E2D56.6090007@oracle.com>
References: <20140930033327.GA14558@redhat.com>
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
	<CA+55aFx_Q7C2a9yCAqK=yWNX1mkcVRdE2bnLOQPHEkMjRcj7KQ@mail.gmail.com>
	<542E2D56.6090007@oracle.com>
Date: Fri, 3 Oct 2014 08:43:57 -0700
X-Google-Sender-Auth: 0AHHIdLX3nnmS3BV063br4UUbFo
Message-ID: <CA+55aFydZt+D68u60MDHUG5r34SmWnDewVFLom7uNwovMzc-CA@mail.gmail.com>
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

On Thu, Oct 2, 2014 at 10:00 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> For the record, I tweaked the environment to put some more pressure on the
> scheduler and found out what broke (which is not related to this thread at
> all).

Ok. It's probably still worth testing Mel's patches, since that's what
goes into 3.17. But it would be interesting to eventually go back to
stability-testing the protnone set, since it *looked* like it was
working well aside from this issue. I might decide to just do it
during the 3.18 merge window..

          Linus
