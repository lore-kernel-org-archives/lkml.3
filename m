Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaECOmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 10:42:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaECOmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 10:42:47 -0400
Message-ID: <53650053.5050402@infradead.org>
Date: Sat, 03 May 2014 07:42:27 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Aaron Tomlin <atomlin@redhat.com>, Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dario Faggioli <raistlin@linux.it>, Jens Axboe <axboe@fb.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/4] test: validate sysctl_writes_strict
References: <1398979597-3589-1-git-send-email-keescook@chromium.org> <1398979597-3589-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1398979597-3589-5-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 02:26 PM, Kees Cook wrote:
> This adds several behavioral tests to sysctl string and number writing
> to detect unexpected cases that behaved differently when the sysctl
> kernel.sysctl_writes_strict != 1.
>
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   kernel/sysctl.c                                 |    4 +-
>   tools/testing/selftests/Makefile                |    1 +
>   tools/testing/selftests/sysctl/Makefile         |   19 ++++
>   tools/testing/selftests/sysctl/common_tests     |  109 +++++++++++++++++++++++
>   tools/testing/selftests/sysctl/run_numerictests |   10 +++
>   tools/testing/selftests/sysctl/run_stringtests  |   77 ++++++++++++++++
>   6 files changed, 218 insertions(+), 2 deletions(-)
>   create mode 100644 tools/testing/selftests/sysctl/Makefile
>   create mode 100644 tools/testing/selftests/sysctl/common_tests
>   create mode 100644 tools/testing/selftests/sysctl/run_numerictests
>   create mode 100644 tools/testing/selftests/sysctl/run_stringtests
>
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index d5bee7949e4a..51bbf904d694 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1783,8 +1783,8 @@ static int _proc_do_string(char *data, int maxlen, int write,
>
>   static void warn_sysctl_write(struct ctl_table *table)
>   {
> -	pr_warn("%s wrote to %s when file position was not 0!\n",
> -		current->task_comm, table->procname);
> +	pr_warn("write to %s by %s used a non-zero file position!\n",
> +		table->procname, current->comm);
>   	pr_warn("This will not be supported in the future.\n");
>   	pr_warn("To silence warning, set kernel.sysctl_writes_strict = -1\n");
>   }

Why is this patch part of the test patch?

-- 
~Randy
