Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbbAFUDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:03:14 -0500
Received: from lists.s-osg.org ([54.187.51.154]:42897 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbbAFUDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:03:13 -0500
Message-ID: <54AC3F80.5060406@osg.samsung.com>
Date: Tue, 06 Jan 2015 13:03:12 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: dann frazier <dann.frazier@canonical.com>, linux-api@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] tools: testing: selftests: mq_perf_tests: Fix infinite
 loop on ARM
References: <1420512880-392-1-git-send-email-dann.frazier@canonical.com>
In-Reply-To: <1420512880-392-1-git-send-email-dann.frazier@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 07:54 PM, dann frazier wrote:
> We can't use a char type to check for a negative return value since char
> isn't guaranteed to be signed. Indeed, the char type tends to be unsigned on
> ARM.
> 
> Signed-off-by: dann frazier <dann.frazier@canonical.com>
> ---
>  tools/testing/selftests/mqueue/mq_perf_tests.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testing/selftests/mqueue/mq_perf_tests.c
> index 94dae65..8519e9e 100644
> --- a/tools/testing/selftests/mqueue/mq_perf_tests.c
> +++ b/tools/testing/selftests/mqueue/mq_perf_tests.c
> @@ -536,10 +536,9 @@ int main(int argc, char *argv[])
>  {
>  	struct mq_attr attr;
>  	char *option, *next_option;
> -	int i, cpu;
> +	int i, cpu, rc;
>  	struct sigaction sa;
>  	poptContext popt_context;
> -	char rc;
>  	void *retval;
>  
>  	main_thread = pthread_self();
> 

Thanks. Applied to kernel/git/shuah/linux-kselftest fixes branch

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
