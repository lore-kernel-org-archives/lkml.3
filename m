Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaK0Fc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 00:32:27 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56863 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaK0Fc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 00:32:26 -0500
Message-ID: <5476B763.1030701@hitachi.com>
Date: Thu, 27 Nov 2014 14:32:19 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org, mmarek@suse.cz,
        davem@davemloft.net, keescook@chromium.org, tranmanphong@gmail.com,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        ebiederm@xmission.com, serge.hallyn@ubuntu.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 02/19] kbuild: kselftest_install - add a new make
 target to install selftests
References: <cover.1415735831.git.shuahkh@osg.samsung.com> <a2344d4df903d673afe1631118f40917f773cc9a.1415735831.git.shuahkh@osg.samsung.com>
In-Reply-To: <a2344d4df903d673afe1631118f40917f773cc9a.1415735831.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/12 5:27), Shuah Khan wrote:
> Add a new make target to install to install kernel selftests.
> This new target will build and install selftests. kselftest
> target now depends on kselftest_install and runs the generated
> kselftest script to reduce duplicate work and for common look
> and feel when running tests.
> 
> Approach:
> 
> make kselftest_target:

kselftest_install?

> -- exports kselftest INSTALL_KSFT_PATH
>    default $(INSTALL_MOD_PATH)/lib/kselftest/$(KERNELRELEASE)
> -- exports path for ksefltest.sh
> -- runs selftests make install target:

This direction is OK to me.

BTW, I've found another path to make selftest in Makefile,
Actually you can do

make -C tools/ selftest

And there are selftest_install and selftest_clean targets (but
currently it has a bug and doesn't work, anyway)

I think we'd better do subdir make instead of adding these targets.
This means that "make kselftest*" should be an alias of "make -C tools/ selftest*"

Also, I'd like to request passing some options like as O=$(objtree)
so that we can make test kmodules in selftests.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


