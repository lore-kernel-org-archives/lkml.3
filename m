Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3JDOZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:25:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57157 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab3JDOZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:25:41 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20131004082847.GA30635@localhost>
References: <20130903143921.GA28290@gmail.com> <CA+55aFxVv==DC0JdS87V+cPr-twN+TujYg5XmgHOjJOAkZ4xwQ@mail.gmail.com> <522763A9.8080708@zytor.com> <20131004082847.GA30635@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] x86/asmlinkage changes for v3.12
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 04 Oct 2013 07:20:44 -0700
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andi Kleen <andi@firstfloor.org>
Message-ID: <58c66734-b162-4185-90f1-006484ee1d0e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for addressing this... you are taking what has already been a key piece of infrastructure for the Linux kernel community and making it even better!

Fengguang Wu <fengguang.wu@intel.com> wrote:
>On Wed, Sep 04, 2013 at 09:45:29AM -0700, H. Peter Anvin wrote:
>[snip]
>> This also exposes an interesting problem with Fengguang's build
>robot.
>> 
>> One build:
>> [tip:x86/asmlinkage] 28596b6a8779b736829ad837f95fdc2e81bdd1ee BUILD
>DONE
>> 28596b6a8779b736829ad837f95fdc2e81bdd1ee  x86, asmlinkage, vdso: Mark
>> vdso variables __visible
>> 
>> ... flags the warnings.  The next build for the branch looks clean:
>> [tip:x86/asmlinkage] eb86b5fd505cb97743d84226140cf247d91a2f03 BUILD
>SUCCESS
>> eb86b5fd505cb97743d84226140cf247d91a2f03  x86/asmlinkage: Fix warning
>in
>> xen asmlinkage change
>> 
>> ("DONE" means warnings or errors.)
>> 
>> A human observer would assume that the problem was fixed, since the
>> patch says "fix warnings", but the problem is that it didn't actually
>> fix *all* the warnings.  However, the bot has flagged the warnings as
>> preexisting from the previous build, and thus no new warnings were
>> introduced.
>
>Yeah sorry! The build robot silently ignored any reported errors,
>which is not the expected behavior when sending BUILD SUCCESS
>notifications.
>
>> It would be better if the bot reported any warnings not present in
>upstream.
>
>I've fixed the robot to remember which tree/branch first introduced
>the build error/warning. If the problem still remains in that branch's
>new HEAD, the robot will be able to send out BUILD DONE reports which
>will include the old error/warning message in the email body.
>
>Sorry for the delay! This feature was added shortly after your report,
>however took long time to confirm that it actually works.
>
>Thanks,
>Fengguang

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
