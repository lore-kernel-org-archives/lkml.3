Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaERTMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 15:12:41 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:56928 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaERTMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 15:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <1400434032.21382.3.camel@joe-AO725>
References: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
	<1400433557-24985-3-git-send-email-massa.nomura@gmail.com>
	<1400434032.21382.3.camel@joe-AO725>
Date: Sun, 18 May 2014 20:12:39 +0100
Message-ID: <CAAvxhqD0zS9+W0Jx3Ut+MQfCWzMmSDwdo+t9mEaL655BRT8qGg@mail.gmail.com>
Subject: Re: [PATCH 2/5] staging: lustre: lnet: socklnd: Clean up memset(...)
From: Masaru Nomura <massa.nomura@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -     memset (peer, 0, sizeof (*peer));       /* NULL pointers/clear flags etc */
>> +     memset(peer, 0, sizeof(*peer));     /* NULL pointers/clear flags etc */
>
> It looks like this memset is unnecessary
> as it's already zeroed by LIBCFS_ALLOC->
> LIBCFS_ALLOC_GFP->LIBCFS_ALLOC_POST->memset.
>
> It seems as if all these ALLOC macros could
> use quite a bit of cleaning/sorting out.

Thank you for pointing it out. I didn't know that nor check the macros.
I'll care about similar problems next time.

I checked the macros and kind of understand what you mean,
but honestly I'm not sure whether or not it's perfectly correct to
remove memset.

If this is the right way, I think we can remove the following memset
which I modified as well.
The reason is the same as you mentioned. conn is zeroed by
LIBCFS_ALLOC before memset.

[PATCH 1/5]
@@ -1041,26 +1041,26 @@ ksocknal_create_conn (lnet_ni_t *ni,
ksock_route_t *route,
                goto failed_0;
        }

-       memset (conn, 0, sizeof (*conn));
+       memset(conn, 0, sizeof(*conn));


Thank you,
Masaru
