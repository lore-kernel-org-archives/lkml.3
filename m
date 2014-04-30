Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946066AbaD3U0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:26:19 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54485 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946028AbaD3U0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <53614BFE.9090804@linux.vnet.ibm.com>
References: <535EA976.1080402@linux.vnet.ibm.com>
	<CA+55aFxgW0fS=6xJsKP-WiOUw=aiCEvydj+pc+zDF8Pvn4v+Jw@mail.gmail.com>
	<CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com>
	<alpine.LSU.2.11.1404281500180.2861@eggly.anvils>
	<1398723290.25549.20.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFwGjYS7PqsD6A-q+Yp9YZmiM6mB4MUYmfR7ro02poxxCQ@mail.gmail.com>
	<535F77E8.2040000@linux.vnet.ibm.com>
	<53614BFE.9090804@linux.vnet.ibm.com>
Date: Wed, 30 Apr 2014 13:26:12 -0700
X-Google-Sender-Auth: UIsIIL2RukozMOTJRsELbm5xU1Q
Message-ID: <CA+55aFyWj3aT4Re4AHKXLrrf3eEheTWH8-q6muU++9FrgaKigA@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at mm/vmacache.c:85!
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Hugh Dickins <hughd@google.com>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 12:16 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
>
> So I tried the same recipe again (boot into 3.7.7 and kexec into 3.15-rc3+)
> and I got totally random crashes so far, once in sys_kill and two times in
> exit_mmap. So I guess the bug is in 3.7.x and probably 3.15-rc is fine after
> all...

Yeah, ok, that sounds more likely. Random memory corruption due to
kexec having done something horribly bad.

              Linus
