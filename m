Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaKYR2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:28:36 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:33753 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaKYR2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:28:34 -0500
MIME-Version: 1.0
In-Reply-To: <20141125155943.GB5050@linux.vnet.ibm.com>
References: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
	<1416919117-50652-3-git-send-email-borntraeger@de.ibm.com>
	<20141125155943.GB5050@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2014 09:28:33 -0800
X-Google-Sender-Auth: tqAYk7CBQMrgblXNxHMKfbzxj9Y
Message-ID: <CA+55aFzY_LSLM8R2cbt=sZe8UeDtUZdX8zO6Bzf52EBg3H30qw@mail.gmail.com>
Subject: Re: [PATCHv2 02/10] kernel: Provide READ_ONCE and ASSIGN_ONCE
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 7:59 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> We really need something like this to catch invalid sizes:
>
>         default: invoke_nonexistent_function();

Actually, I wonder if we should make the default: case actually just
do something like

   barrier();
   memcpy(res, p, size);
   barrier();

which in no way guarantees that it's an _atomic_ access, but it does
guarantee the semantics that you get one particular value and it won't
get reloaded later..

That would solve the crazy sparc pte issue too.


               Linus
