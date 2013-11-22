Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3KVAe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:34:27 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:60120 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3KVAe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:34:26 -0500
Message-ID: <528EA67D.5080901@ahsoftware.de>
Date: Fri, 22 Nov 2013 01:34:05 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Lozano <llozano@chromium.org>,
        Bhaskar Janakiraman <bjanakiraman@chromium.org>,
        Han Shen <shenhan@chromium.org>
Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
References: <52803E5D.3050109@mentor.com>	<52851395.3010306@mentor.com>	<67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>	<1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>	<CA+55aFw923sA0E1RQNxFF0OWFtAfcaG-dBUc-0YYZGDSAsaQyg@mail.gmail.com>	<528E2E8E.8080004@ahsoftware.de>	<CA+55aFyNZun07BLoD2KQFT7cN1xsiQ2gE6hYwRvOGa3tCap4CQ@mail.gmail.com>	<528E94E2.3080102@ahsoftware.de> <CA+55aFx2BTQLFLU0BdXrzYR55SZT_UZ4BjbYoMUZ8bt-p1XENg@mail.gmail.com>
In-Reply-To: <CA+55aFx2BTQLFLU0BdXrzYR55SZT_UZ4BjbYoMUZ8bt-p1XENg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.11.2013 01:17, schrieb Linus Torvalds:
> On Thu, Nov 21, 2013 at 3:18 PM, Alexander Holler <holler@ahsoftware.de> wrote:

> Basically, your whole argument boils down to "if the function did
> something else than what it does, then it wouldn't be const, so we
> shouldn't mark it const". But that argument is BULLSHIT, because the
> fact is, the function *doesn't* do what you try to claim it does.

Maybe gcc just makes the same false conclusion as I did in my description.

I read it as current_thread_info() returns "a pointer to something 
local" instead of returns "a pointer". Might be BULLSHIT but would 
explain the bug which seems to exist.

Alexander Holler

