Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbbASAfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 19:35:55 -0500
Received: from ozlabs.org ([103.22.144.67]:48679 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbbASAfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 19:35:50 -0500
Message-ID: <1421627747.3787.7.camel@ellerman.id.au>
Subject: Re: [PATCH 4/6] kbuild: add a new kselftest_install make target to
 install selftests
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, mmarek@suse.cz, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, keescook@chromium.org, tranmanphong@gmail.com,
        cov@codeaurora.org, dh.herrmann@gmail.com, hughd@google.com,
        bobby.prani@gmail.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Date: Mon, 19 Jan 2015 11:35:47 +1100
In-Reply-To: <54B93DA1.2010601@osg.samsung.com>
References: <1420794375-31881-1-git-send-email-mpe@ellerman.id.au>
	 <1420794375-31881-4-git-send-email-mpe@ellerman.id.au>
	 <54B93DA1.2010601@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-16 at 09:34 -0700, Shuah Khan wrote:
> On 01/09/2015 02:06 AM, Michael Ellerman wrote:
> > Add a new make target to install kernel selftests. This new target will
> > build and install selftests.
> > 
> > The default is just $(objtree)/selftests. This is preferable to
> > something based on $(INSTALL_MOD_PATH) (which defaults to /), as it
> > allows a normal user to install the tests. This is similar to the
> > default behaviour of make headers_install.
> 
> A normal user can install tests at any location they choose by
> overriding the default path. For example:
> 
> INSTALL_MOD_PATH=/tmp make kselftest_install
> 
> will install under tmp.

Why default to a directory that most users can't write to? That's not helpful.

Users who are root can override the path, for example:

INSTALL_MOD_PATH=/ make kselftest_install

> The approach I used also ties test installs to kernel release.
> This addresses an important use-case for kernel developers
> that want to compare results from release to release.

Sure, I'm happy to add the kernel release, so the default would be
$(objtree)/selftests/$(kernel-release)/.

> The use-case for any user to be able to install tests at
> any location is addressed by the above example.

The default should work for most users most of the time, / does not achieve
that.

> I would like these two above use-cases continued to be supported,
> especially the one that tries the test installs to kernel release.

That's fine, I'm happy to update this to use kernel release. But defaulting to
/ doesn't make sense.

> Another goal is to keep changes to the main Makefile minimal and
> the rest of the install support belongs under selftests/Makefile
> and any other include file (like the one you proposed).

Yes, this patch does just that.

cheers


