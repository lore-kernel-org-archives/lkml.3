Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3HTVDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:03:36 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40397 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3HTVDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:03:35 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw94ow=aYF-y9kJu+2ZsA=YLob5wFe01H+ooQmP6EbJvQ@mail.gmail.com>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
 <1376089460-5459-11-git-send-email-andi@firstfloor.org> <CA+55aFyN2Cnt=uQOnXszwDA971o=xEwO=yFSgL-RH9vRjMsBbg@mail.gmail.com>
 <20130810161031.GK19750@two.firstfloor.org> <CA+55aFw94ow=aYF-y9kJu+2ZsA=YLob5wFe01H+ooQmP6EbJvQ@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 20 Aug 2013 17:03:14 -0400
Message-ID: <CAHGf_=p-HKz7FZ9cW7k+_64G2e+YtqaYc7mgK1ZvZoHjae+ABw@mail.gmail.com>
Subject: Re: [PATCH 10/13] x86: Move cond resched for copy_{from,to}_user into
 low level code 64bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hmm. I can do that, but wouldn't that make CONFIG_PREEMPT_VOLUNTARY
>> mostly equivalent to CONFIG_PREEMPT_NONE?
>
> According the the Kconfig help, PREEMPT_VOLUNTARY is about the
> *explicit* preemption points. And we do have a lot of them in
> "might_sleep()".
>
> And personally, I think it makes a *lot* more sense to have a
> "might_sleep()" in the MM allocators than it does to have it in
> copy_from_user().

AFAIK, MM allocation already does that.

struct page *
__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
struct zonelist *zonelist, nodemask_t *nodemask)
{
(snip)
   might_sleep_if(gfp_mask & __GFP_WAIT);


btw, Sorry for the very late response. I haven't noticed this thread.
