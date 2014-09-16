Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaIPHFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:05:25 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:35493 "EHLO
	homiemail-a9.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636AbaIPHFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:05:22 -0400
Message-ID: <1410883441.4630.9.camel@linux-t7sj.site>
Subject: Re: [PATCH 1/7] selftests: add header file for test exit code
 defines
From: Davidlohr Bueso <dave@stgolabs.net>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com,
        felipensp@gmail.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Sep 2014 18:04:01 +0200
In-Reply-To: <1410820442-8774-2-git-send-email-shuahkh@osg.samsung.com>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
	 <1410820442-8774-2-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 16:33 -0600, Shuah Khan wrote:
> Add a new header file that defines exit codes for individual
> tests to use to communicate test results. These defines are
> intended to provide a common and uniform way for selftests
> to report results. pass/fail/xfail/xpass/skip/unsupported
> are defined.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  tools/testing/selftests/kselftest.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 tools/testing/selftests/kselftest.h
> 
> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
> new file mode 100644
> index 0000000..1b1c9cb
> --- /dev/null
> +++ b/tools/testing/selftests/kselftest.h
> @@ -0,0 +1,20 @@
> +/*
> + * kselftest.h - kselftest framework return codes to include from
> + *		 selftests.
> + *
> + * Copyright (c) 2014 Shuah Khan <shuahkh@osg.samsung.com>
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *
> + * This file is released under the GPLv2.
> + */
> +#ifndef __KSELFTEST_H
> +#define __KSELFTEST_H
> +
> +#define	EXIT_PASS		0
> +#define	EXIT_FAIL		1
> +#define	EXIT_XFAIL		2
> +#define	EXIT_XPASS		3
> +#define	EXIT_SKIP		4
> +#define	EXIT_UNSUPPORTED	EXIT_SKIP

Looks to me like a potential name clashes here.

What's the difference between XFAIL/XPASS and regular FAIL/PASS (I don't
see the former used in patchset either, only PASS/FAIL)? What's the
purpose of EXIT_SKIP? I think overall these should be commented.

Also, in the bigger picture, I'm guessing you have a reason for not
recycling errno and inventing your own exit codes... How do you plan on
using these? In addition I'm seeing things like:

-       exit(EXIT_FAILURE);
+       exit(EXIT_FAIL);

which isn't a very good idea in general.

