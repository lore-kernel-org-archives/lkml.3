Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaJWNHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:07:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41686 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaJWNHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:07:00 -0400
Message-ID: <5448FD72.9040301@codeaurora.org>
Date: Thu, 23 Oct 2014 09:06:58 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, shuahkh@osg.samsung.com,
        linux-api@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
        gorcunov@openvz.org
Subject: Re: [PATCH 3/3] selftests/kcmp: Always try to build the test
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au> <1414040834-30209-3-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1414040834-30209-3-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 10/23/2014 01:07 AM, Michael Ellerman wrote:
> Don't prevent the test building on non-x86. Just try and build it and
> let the chips fall where they may.

As a user of kcmp via CRIU on arm and arm64, thanks!

> diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
> index 4f00c0524501..cda9cc4004c9 100644
> --- a/tools/testing/selftests/kcmp/Makefile
> +++ b/tools/testing/selftests/kcmp/Makefile
> @@ -1,21 +1,7 @@
> -uname_M := $(shell uname -m 2>/dev/null || echo not)
> -ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
> -ifeq ($(ARCH),i386)
> -        ARCH := x86
> -	CFLAGS := -DCONFIG_X86_32 -D__i386__
> -endif
> -ifeq ($(ARCH),x86_64)
> -	ARCH := x86
> -	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
> -endif
>  CFLAGS += -I../../../../usr/include/
>  
>  all:
> -ifeq ($(ARCH),x86)
>  	gcc $(CFLAGS) kcmp_test.c -o kcmp_test

Not that this needs to be addressed in this patch, but this looks broken for
cross compilation. It looks like some of the other selftests use:

CC = $(CROSS_COMPILE)gcc

But perhaps this should be set (and perhaps with ':=') once at the top level.

Chris

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
