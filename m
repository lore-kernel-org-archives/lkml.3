Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbaCNTIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbaCNTIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:08:36 -0400
Date: Fri, 14 Mar 2014 15:08:24 -0400
From: Dave Jones <davej@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
Message-ID: <20140314190824.GA6426@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sasha.levin@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
 <5321CBDA.1060705@oracle.com>
 <CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
 <20140313231227.GA32178@redhat.com>
 <CAGXu5jLE6WHCwZVcMSUwQAa3=DW1LsxGd_1aGo8SzLpk8jC-xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLE6WHCwZVcMSUwQAa3=DW1LsxGd_1aGo8SzLpk8jC-xA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 11:31:11AM -0700, Kees Cook wrote:
 > On Thu, Mar 13, 2014 at 4:12 PM, Dave Jones <davej@redhat.com> wrote:
 > > On Thu, Mar 13, 2014 at 03:03:41PM -0700, Linus Torvalds wrote:
 > >
 > >  > You need to look at the *symbol* number. In this output:
 > >  >
 > >  >      [<ffffffff810020c2>] do_one_initcall+0xc2/0x1e0
 > >  >
 > >  > that "ffffffff810020c2" is crap, and is going away. The address that
 > >  > is meaningful and valid is the "do_one_initcall+0xc2" part.
 > >  >
 > >  > *That* is the part you'd use to parse in user space.
 > >  >
 > >  > Try it today with the CONFIG_RANDOMIZE_BASE option to see. Using the
 > >  > hex number doesn't *work*.
 > >
 > > That reminds me, perf top is still busted when this option is enabled.
 > 
 > Hrm, works for me. I'm not very familiar with what to expect, but
 > comparing output between kaslr boot and nokaslr boot, it looks the
 > same to me.

ok, nokalsr makes it work too.
Booting with that and using the perf binary from 3.14rc6 , I just see..

  9.30%  [kernel]                      [k] 0xffffffffaf18e887
  7.98%  [kernel]                      [k] 0xffffffffaf3276c7
  6.10%  [kernel]                      [k] 0xffffffffaf18dd3a
  4.39%  [kernel]                      [k] 0xffffffffaf327717
  1.71%  [kernel]                      [k] 0xffffffffaf18e89c
  1.52%  [kernel]                      [k] 0xffffffffaf3276cc

Curiously, if I use the perf binary from 3.13, I see everything lumped together as..

 95.89%  [kernel].exit.text            [k] 0x000000002e586c26

(When kaslr is disabled both binaries work fine)

Also maybe related: The rc6 binary claims it can't read symbols from vmlinux
when kaslr is enabled.

	Dave

