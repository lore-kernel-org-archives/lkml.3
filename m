Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbaIWWlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:41:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55200 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbaIWWlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:41:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, serge.hallyn@ubuntu.com,
        thierry@linux.vnet.ibm.com, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
	<cover.1411506121.git.shuahkh@osg.samsung.com>
	<969f0780734a04763f2b54063603b93380244d0c.1411506121.git.shuahkh@osg.samsung.com>
Date: Tue, 23 Sep 2014 15:41:20 -0700
In-Reply-To: <969f0780734a04763f2b54063603b93380244d0c.1411506121.git.shuahkh@osg.samsung.com>
	(Shuah Khan's message of "Tue, 23 Sep 2014 15:32:58 -0600")
Message-ID: <87d2am2c4v.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19UgBNZ2T1wBibntGhkAL6bVeMWyDpercc=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 XM_Superlative01 Best-rated language
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4891]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Shuah Khan <shuahkh@osg.samsung.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 5/7] selftests/mount: change test to use ksft framework
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuah Khan <shuahkh@osg.samsung.com> writes:

> Change mount test to use kselftest framework to report
> test results.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I am curious did you even run these tests?   I can't possibly see how
the tests would have passed with this change.  At the very least you
have taken this test from linear to exponential time complexity.

> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  tools/testing/selftests/mount/unprivileged-remount-test.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
> index 1b3ff2f..c64d442 100644
> --- a/tools/testing/selftests/mount/unprivileged-remount-test.c
> +++ b/tools/testing/selftests/mount/unprivileged-remount-test.c
> @@ -13,6 +13,8 @@
>  #include <stdbool.h>
>  #include <stdarg.h>
>  
> +#include "../kselftest.h"
> +
>  #ifndef CLONE_NEWNS
>  # define CLONE_NEWNS 0x00020000
>  #endif
> @@ -45,7 +47,7 @@ static void die(char *fmt, ...)
>  	va_start(ap, fmt);
>  	vfprintf(stderr, fmt, ap);
>  	va_end(ap);
> -	exit(EXIT_FAILURE);
> +	ksft_exit_fail();
>  }
>  
>  static void write_file(char *filename, char *fmt, ...)
> @@ -176,7 +178,7 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
>  		die("remount of /tmp with invalid flags "
>  		    "succeeded unexpectedly\n");
>  	}
> -	exit(EXIT_SUCCESS);
> +	return ksft_exit_pass();

This change is a deep bug. 

This exit is a forked child process (not from the test itself). That a
few lines earlier in the test I test the value of in waitpid.

Also in your change commit comment if no where else you should have
called out that you were making a semantic change to the test.

>  }
>  
>  static bool test_unpriv_remount_simple(int mount_flags)
> @@ -238,5 +240,5 @@ int main(int argc, char **argv)
>  	{
>  		die("Default atime malfunctions\n");
>  	}
> -	return EXIT_SUCCESS;
> +	return ksft_exit_pass();
>  }
