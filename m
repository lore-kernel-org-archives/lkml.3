Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbaGWPM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:12:56 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:39644 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743AbaGWPMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:12:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140723104917.GB23102@pd.tnic>
References: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
 <CA+55aFyefnFjmOs-QZhFn68-6+tWO30VqU6ipP6BzAra=xOaFg@mail.gmail.com>
 <CALCETrUjKXfwbWkUytMXLSmKROLBVY7tRYWPHnEC01Fj=aiTkQ@mail.gmail.com> <20140723104917.GB23102@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 23 Jul 2014 08:12:32 -0700
Message-ID: <CALCETrVzKJZiEmxuVNv8_7dybh-4AQYRA5Yb5ms+vK9CKYEorA@mail.gmail.com>
Subject: Re: STI architectural question (and lretq -- I'm not even kidding)
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 23, 2014 3:49 AM, "Borislav Petkov" <bp@alien8.de> wrote:
>
> On Tue, Jul 22, 2014 at 06:33:02PM -0700, Andy Lutomirski wrote:
> > Of course, this does nothing at all to protect us from #MC after sti
> > on return from #MC to userspace, but I think we're screwed regardless
> > -- we could just as easily get a second #MC before the sti. Machine
> > check broadcast was the worst idea ever.
>
> Please do not think that a raised #MC means the machine is gone. There
> are MC errors which are reported with the exception mechanism and from
> which we can and do recover, regardless of broadcasting or not.
>

How are we supposed to survive two machine checks in rapid succession?
 The second will fire as soon as the first one is acked, I imagine.
Unless we switch stacks before acking the MCE, the return address of
the first one will be lost.

In any event, I'll do a manual fixup for this in my patch.


--Andy
