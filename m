Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657AbaEFB3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:29:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56768 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507AbaEFB3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <53650053.5050402@infradead.org>
References: <1398979597-3589-1-git-send-email-keescook@chromium.org>
	<1398979597-3589-5-git-send-email-keescook@chromium.org>
	<53650053.5050402@infradead.org>
Date: Mon, 5 May 2014 18:29:49 -0700
X-Google-Sender-Auth: 49EDF8ombA-9JeH7yzy3MwP5x-w
Message-ID: <CAGXu5j+GbUDEsppLcVy+PaQSkX3=rsdyRhw7PbLYj3WMraT1Bg@mail.gmail.com>
Subject: Re: [PATCH 4/4] test: validate sysctl_writes_strict
From: Kees Cook <keescook@chromium.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Aaron Tomlin <atomlin@redhat.com>, Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dario Faggioli <raistlin@linux.it>, Jens Axboe <axboe@fb.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2014 at 7:42 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 05/01/2014 02:26 PM, Kees Cook wrote:
>>
>> This adds several behavioral tests to sysctl string and number writing
>> to detect unexpected cases that behaved differently when the sysctl
>> kernel.sysctl_writes_strict != 1.
>>
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>   kernel/sysctl.c                                 |    4 +-
>>   tools/testing/selftests/Makefile                |    1 +
>>   tools/testing/selftests/sysctl/Makefile         |   19 ++++
>>   tools/testing/selftests/sysctl/common_tests     |  109
>> +++++++++++++++++++++++
>>   tools/testing/selftests/sysctl/run_numerictests |   10 +++
>>   tools/testing/selftests/sysctl/run_stringtests  |   77 ++++++++++++++++
>>   6 files changed, 218 insertions(+), 2 deletions(-)
>>   create mode 100644 tools/testing/selftests/sysctl/Makefile
>>   create mode 100644 tools/testing/selftests/sysctl/common_tests
>>   create mode 100644 tools/testing/selftests/sysctl/run_numerictests
>>   create mode 100644 tools/testing/selftests/sysctl/run_stringtests
>>
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index d5bee7949e4a..51bbf904d694 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -1783,8 +1783,8 @@ static int _proc_do_string(char *data, int maxlen,
>> int write,
>>
>>   static void warn_sysctl_write(struct ctl_table *table)
>>   {
>> -       pr_warn("%s wrote to %s when file position was not 0!\n",
>> -               current->task_comm, table->procname);
>> +       pr_warn("write to %s by %s used a non-zero file position!\n",
>> +               table->procname, current->comm);
>>         pr_warn("This will not be supported in the future.\n");
>>         pr_warn("To silence warning, set kernel.sysctl_writes_strict =
>> -1\n");
>>   }
>
>
> Why is this patch part of the test patch?

Oops, thanks. Yeah, that snuck into the wrong patch.

-Kees

-- 
Kees Cook
Chrome OS Security
