Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3LOOw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 09:52:59 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:65338 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3LOOw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 09:52:58 -0500
Message-ID: <52ADC23F.3040302@linux.com>
Date: Sun, 15 Dec 2013 15:52:47 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Doron Tsur <doront@mellanox.com>, linux-kernel@vger.kernel.org
CC: itaib@mellanox.com
Subject: Re: [PATCH] include/uapi/linux/netlink.h -Wall -Wextra -Werror support
 fix
References: <1387118409-30636-1-git-send-email-doront@mellanox.com>
In-Reply-To: <1387118409-30636-1-git-send-email-doront@mellanox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2013 03:40 PM, Doron Tsur wrote:
> For code using:
>     #include <linux/netlink.h>
>     NLMSG_OK
>     -I<INSTALL_HDR_PATH>/include
> 
> Tested-by: Doron Tsur <doront@mellanox.com>
This should go where your Signed-off-by line is.

[insert newlines here]
> Test log:
> Compilation environments:
> Ubuntu 13.10, x86_64, gcc (Ubuntu/Linaro 4.8.1-10ubuntu9) 4.8.1
> Ubuntu 13.04, x86_64, gcc (Ubuntu/Linaro 4.7.3-1ubuntu1) 4.7.3
> [ -ftrack-macro-expansion=2 issue submitted:
>   gcc.gnu.org/bugzilla/show_bug.cgi?id=59495 ]


[insert newlines here]
> Kernel headers installed at:
> make -C .../linux-stable headers_install \
>     INSTALL_HDR_PATH=/builds/kernel_tests_user_headers/


[insert newlines here]
> Pre-patch compilation:
> gcc -Wall -Wextra -Werror
> -I/builds/kernel_tests_pre_patch_user_headers/include
> include-uapi-linux-netlink.h.test.c
> In file included from include-uapi-linux-netlink.h.test.c:2:0:
> include-uapi-linux-netlink.h.test.c: In function ‘main’:
> /builds/kernel_tests_pre_patch_user_headers/include/linux/netlink.h:89:24:
> error: comparison between signed and unsigned integer expressions
> [-Werror=sign-compare]
>        (nlh)->nlmsg_len <= (len))
>                         ^
> include-uapi-linux-netlink.h.test.c:26:5: note: in expansion of macro ‘NLMSG_OK’
>      NLMSG_OK(&auxiliary_netlink_header, active_len));
>      ^
> cc1: all warnings being treated as errors


[insert newlines here]
> Post-patch:
> $ gcc  -Wall -Wextra -Werror
> -I/builds/kernel_tests_user_headers/include/
> include-uapi-linux-netlink.h.test.c


[insert newlines here]
> $ ./a.out
> nlmsg_len= 1, len = 1 NLMSG_OK(nlh,len) test result: 0
> nlmsg_len= 1, len = 3000 NLMSG_OK(nlh,len) test result: 0
> nlmsg_len= 3000, len = 1 NLMSG_OK(nlh,len) test result: 0
> nlmsg_len= 3000, len = 3000 NLMSG_OK(nlh,len) test result: 1
> 
> Signed-off-by: Doron Tsur <doront@mellanox.com>

Please make your commit message understandable by adding newlines and such.
Also it doesn't say what did you change and why. All it says, that there
was a warning and post-patch there is no warning.

-- 
Regards,
Levente Kurusa
