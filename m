Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaBHXOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 18:14:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29839 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaBHXOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 18:14:45 -0500
Message-ID: <52F6BA4E.9080305@oracle.com>
Date: Sat, 08 Feb 2014 18:14:22 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Geng Hui <hui.geng@huawei.com>
Subject: Re: [PATCH resend 1/2] liblockdep: Use realpath for srctree and objtree
References: <1390730778-30366-1-git-send-email-wangnan0@huawei.com> <1391823820-11154-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1391823820-11154-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

Thanks! I've picked it up and will send it in the next pull request.


Thanks,
Sasha

On 02/07/2014 08:43 PM, Wang Nan wrote:
> If BUILD_SRC or CURDIR contains tailing '/', the file names passed to gcc will
> contain '//'. It will be contained .o's in debuginfo, then confuse debugedit:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=304121
>
> This patch uses realpath command to makesure potential tailing '/'s are removed.
>
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Acked-by: Sasha Levin <sasha.levin@oracle.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Geng Hui <hui.geng@huawei.com>
>
> ---
>   tools/lib/lockdep/Makefile | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
> index da8b7aa..e638dd5 100644
> --- a/tools/lib/lockdep/Makefile
> +++ b/tools/lib/lockdep/Makefile
> @@ -87,8 +87,8 @@ endif # BUILD_SRC
>   # We process the rest of the Makefile if this is the final invocation of make
>   ifeq ($(skip-makefile),)
>
> -srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
> -objtree		:= $(CURDIR)
> +srctree		:= $(realpath $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR)))
> +objtree		:= $(realpath $(CURDIR))
>   src		:= $(srctree)
>   obj		:= $(objtree)
>
>

