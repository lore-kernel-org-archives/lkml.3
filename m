Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbbAPQfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:35:21 -0500
Received: from lists.s-osg.org ([54.187.51.154]:44592 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbbAPQfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:35:19 -0500
Message-ID: <54B93DA1.2010601@osg.samsung.com>
Date: Fri, 16 Jan 2015 09:34:41 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
CC: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, cov@codeaurora.org,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4/6] kbuild: add a new kselftest_install make target to
 install selftests
References: <1420794375-31881-1-git-send-email-mpe@ellerman.id.au> <1420794375-31881-4-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1420794375-31881-4-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 02:06 AM, Michael Ellerman wrote:
> Add a new make target to install kernel selftests. This new target will
> build and install selftests.
> 
> The default is just $(objtree)/selftests. This is preferable to
> something based on $(INSTALL_MOD_PATH) (which defaults to /), as it
> allows a normal user to install the tests. This is similar to the
> default behaviour of make headers_install.

A normal user can install tests at any location they choose by
overriding the default path. For example:

INSTALL_MOD_PATH=/tmp make kselftest_install

will install under tmp.

The approach I used also ties test installs to kernel release.
This addresses an important use-case for kernel developers
that want to compare results from release to release.

The use-case for any user to be able to install tests at
any location is addressed by the above example.

I would like these two above use-cases continued to be supported,
especially the one that tries the test installs to kernel release.
Another goal is to keep changes to the main Makefile minimal and
the rest of the install support belongs under selftests/Makefile
and any other include file (like the one you proposed).

The patch I have in patch v4 addresses the use-cases mentioned above.
I do like the lib.mk approach in general and I am going to review that
patch and give you feedback.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
