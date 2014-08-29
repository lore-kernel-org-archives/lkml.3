Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaH2BFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:05:48 -0400
Received: from lists.s-osg.org ([54.187.51.154]:52168 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaH2BFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:05:47 -0400
Message-ID: <53FFD1E8.6070508@osg.samsung.com>
Date: Thu, 28 Aug 2014 19:05:44 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 4/4] ftracetest: Add XFAIL/XPASS/UNSUPPORTED as
 result code
References: <20140826111511.5711.28493.stgit@kbuild-fedora.novalocal> <20140826111539.5711.93588.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140826111539.5711.93588.stgit@kbuild-fedora.novalocal>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 05:15 AM, Masami Hiramatsu wrote:
> Add XFAIL, XPASS and UNSUPPORTED as a result code. These are
> used for the results that test case is expected to fail or
> unsupported feature (by config).
> This also introduces PASS/FAIL/XFAIL/XPASS/UNSUP result codes
> for each testcase. Since the results are not binary, each
> testcase must use these code to return the test result.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  tools/testing/ftrace/ftracetest                    |   61 +++++++++++++++-----
>  tools/testing/ftrace/test.d/basic1.tc              |    6 ++
>  tools/testing/ftrace/test.d/basic2.tc              |    6 +-
>  tools/testing/ftrace/test.d/basic3.tc              |    9 ++-
>  .../testing/ftrace/test.d/kprobe/add_and_remove.tc |   15 +++--
>  tools/testing/ftrace/test.d/kprobe/busy_check.tc   |   20 +++----
>  tools/testing/ftrace/test.d/template               |    6 ++
>  7 files changed, 84 insertions(+), 39 deletions(-)
> 
> diff --git a/tools/testing/ftrace/ftracetest b/tools/testing/ftrace/ftracetest
> index 0378c8a..bfcd56a 100755
> --- a/tools/testing/ftrace/ftracetest
> +++ b/tools/testing/ftrace/ftracetest
> @@ -107,22 +107,53 @@ catlog() { #file
>  }
>  
>  # Testcase management
> +# Test result codes
> +PASS=0	# The test succeeded.
> +FAIL=1	# The test failed, but was expected to succeed.
> +XFAIL=2	# The test failed, and was expected to fail.
> +XPASS=3	# The test succeeded, but was expected to fail.

This one is confusing. It is still a failure. XFAIL case is
expected to fail, using that convention XPASS should be
expected to pass?

Can we use XFAIL0 for XFAIL pass case and XFAIL1 for XFAIL fail
case?

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
