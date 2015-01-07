Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbbAGTVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:21:25 -0500
Received: from lists.s-osg.org ([54.187.51.154]:43032 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbbAGTVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:21:24 -0500
Message-ID: <54AD872E.9060802@osg.samsung.com>
Date: Wed, 07 Jan 2015 12:21:18 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrey Skvortsov <andrej.skvortzov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/vm: fix link error for transhuge-stress test
References: <1420655754-10076-1-git-send-email-Andrej.Skvortzov@gmail.com>
In-Reply-To: <1420655754-10076-1-git-send-email-Andrej.Skvortzov@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 11:35 AM, Andrey Skvortsov wrote:
> add -lrt to fix undefined reference to `clock_gettime'
> 
> Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
> ---
>  tools/testing/selftests/vm/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
> index 4c4b1f6..077828c 100644
> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -7,7 +7,7 @@ BINARIES += transhuge-stress
>  
>  all: $(BINARIES)
>  %: %.c
> -	$(CC) $(CFLAGS) -o $@ $^
> +	$(CC) $(CFLAGS) -o $@ $^ -lrt
>  
>  run_tests: all
>  	@/bin/sh ./run_vmtests || (echo "vmtests: [FAIL]"; exit 1)
> 

Andrey,

I don't see any undefined references when I build. Curious if it is
specific to your env??

Please include the warning in the change log
when you fix warnings in the future.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
