Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbaDVQgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:36:00 -0400
Received: from natasha.panasas.com ([209.166.131.148]:46482 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642AbaDVQfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:35:54 -0400
From: Jim Lieb <jlieb@panasas.com>
To: Boaz Harrosh <openosd@gmail.com>
CC: Florian Weimer <fweimer@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <bfields@redhat.com>
Subject: Re: Re: Thoughts on credential switching
Date: Tue, 22 Apr 2014 09:35:40 -0700
Message-ID: <3188256.8buApyBF7d@jlieb-e6410>
Organization: Panasas Inc.
User-Agent: KMail/4.11.5 (Linux/3.13.9-100.fc19.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53565D29.6010503@gmail.com>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com> <53565491.702@redhat.com> <53565D29.6010503@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2014 15:14:33 Boaz Harrosh wrote:
> On 04/22/2014 02:37 PM, Florian Weimer wrote:
> > On 03/27/2014 02:33 PM, Boaz Harrosh wrote:
> >> POSIX or not it just does not have any real programming mining
> >> at all.
> > 
> > What do you mean with "mining" in this context?
> 
> Sorry I saw this mistake after I posted. I meant "meaning".
> 
> What I'm saying is that the mess starts when you are trying
> to keep patching a very wrong API. the POSIX politics aside,
> in regard to user switching (and current directory and etc...)
> this API is plain WRONG. I mean in the mathematical sense wrong.
> 
> All these application mess is not the application programmers
> fault. He had to do what he had to do. The mess starts when you
> are trying to keep a mathematical contradiction in your proof.
> 
> It is glibc mess for trying to maintain compatibility with
> these "PROCESS WIDE OPERATIONS". And naming it holy names like
> POSIX will not cover the mess that they are. As long as you try
> to keep them there will be mess. If you want to honestly clean
> things up is by throwing the true garbage out. Convert all legacy
> code to new mathematically sound API's.
> 
> Peace
> Boaz

I don't want to keep this churning thread going.  I'd rather solve today's 
problems.  So let's put this in perspective and move on.  Our project has a 
problem to solve.

I wouldn't necessarily say wrong, simply very out of date.  All of these 
issues with POSIX and pthreads in particular come from one common source, the 
actual capabilities of the systems, BSD, and SysV at the time.  The goofy 
localtime_r and friends were (and still are) hacks to work around the 
simplistic interfaces in the original Bell Labs code that deeply assumed a 
single process with a single thread, i.e. there were only 3 segments, no 
shared libraries or shared r/w memory and definitely no (real) TLS.  The 
pthreads interfaces deeply assumed the same.  Even worse, it had to also run 
on VMS which (I don't believe) ever had kernel support for multiple user space 
theads.  ASTs are nasty enough and only worked because everybody knew that you 
were either in app code or the AST...  So all of this stuff is based on lowest 
common denominator.  The "Single UNIX Specification" was a peace treaty among 
warring computer companies out looking for lock-ins and competitive advantages 
while reluctantly realizing that the ISV community (Oracle) really didn't care 
about anything but a common base.

Let's move on.  Glibc has to keep some semblance of POSIX in order to cope 
with legacy code from that era and I commend them for their perseverance.  But 
that should not hold us back from leveraging today's architectures and, more 
importantly, today's multi-client workloads.  If that means extensions to 
POSIX fine.  But if POSIX gets hung up because *BSD doesn't have kernel support 
for thread level creds and *bsd.org doesn't want to do it, we just do what fits 
today's requirements and what Linux is capable of,

Jim
-- 
Jim Lieb
Linux Systems Engineer
Panasas Inc.

"If ease of use was the only requirement, we would all be riding tricycles"
- Douglas Engelbart 1925–2013
