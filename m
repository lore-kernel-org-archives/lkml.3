Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3FXJKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:10:14 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34586 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab3FXJKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:10:12 -0400
Message-ID: <51C80CF0.4070608@imgtec.com>
Date: Mon, 24 Jun 2013 10:10:08 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, David Daney <ddaney@caviumnetworks.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        <linux-mips@linux-mips.org>
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com> <51C47864.9030200@gmail.com> <20130621202244.GA16610@redhat.com> <51C4BB86.1020004@caviumnetworks.com> <20130622190940.GA14150@redhat.com>
In-Reply-To: <20130622190940.GA14150@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_24_10_10_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/06/13 20:09, Oleg Nesterov wrote:
> On 06/21, David Daney wrote:
>> I am proposing that we just reduce the number of usable signals such
>> that existing libc status checking macros/functions don't change in any
>> way.
> 
> And I fully agree! Absolutely, sorry for confusion.
> 
> 
> What I tried to say, _if_ we change the ABI instead, lets make this
> change sane.

I agree that this approach isn't very nice (I was really just trying to
explore the options) and reducing the number of signals is nicer. But is
anybody here confident enough that the number of signals changing under
the feet of existing binaries/libc won't actually break anything real?
I.e. anything trying to use SIGRTMAX() to get a lower priority signal.

> 
> To me this hack is not sane. And btw, the patch doesn't look complete.
> Say, wait_task_zombie() should do exitcode_to_sig() for ->si_status.

Ah yes, I didn't seen that.

Cheers
James

