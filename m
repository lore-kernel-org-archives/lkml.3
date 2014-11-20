Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbaKTUad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:30:33 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:54760 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaKTUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:30:31 -0500
MIME-Version: 1.0
In-Reply-To: <546DD2DE.9080405@de.ibm.com>
References: <1415360716-9670-2-git-send-email-borntraeger@de.ibm.com>
	<54611D86.4040306@de.ibm.com>
	<CA+55aFyEigSL64RJH8AO86gFBBB84+dgk7eEUPx=CaLwJMcO_w@mail.gmail.com>
	<546DD2DE.9080405@de.ibm.com>
Date: Thu, 20 Nov 2014 12:30:30 -0800
X-Google-Sender-Auth: PJ6lUW2vQ2m5rGZHfXnvoLcK7nE
Message-ID: <CA+55aFzxSa0qM5iC-aM4mh=qni0r87_gHR3tN6Xzo0miYSrcgw@mail.gmail.com>
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

On Thu, Nov 20, 2014 at 3:39 AM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> So It looks like we could make a change to ACCESS_ONCE. Would something like
>
> CONFIG_ARCH_SCALAR_ACCESS_ONCE be a good start?

No, if it's just a handful of places to be fixed, let's not add config
options for broken cases.

> This would boil down to
> Patch1: Provide stricter ACCESS_ONCE if CONFIG_ARCH_SCALAR_ACCESS_ONCE is set + docu update + comments
> Patch2: Change mm/* to barriers
> Patch3: Change x86 locks
> Patch4: Change x86 gup
> Patch4: Enable CONFIG_ARCH_SCALAR_ACCESS_ONCE for s390x and x86

Just do patches 2-4 first, and then patch 1 unconditionally.

Obviously you'd need to spread the word on linux-arch to see how bad
it is for other cases, but if other architectures are at all like x86
and s390, and just require a few trivial patches, let's not make this
some config option.

                   Linus
