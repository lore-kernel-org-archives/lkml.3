Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaHSN21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:28:27 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55128 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaHSN20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:28:26 -0400
MIME-Version: 1.0
In-Reply-To: <1408438302-24123-1-git-send-email-dmonakhov@openvz.org>
References: <1408438302-24123-1-git-send-email-dmonakhov@openvz.org>
Date: Tue, 19 Aug 2014 22:28:24 +0900
Message-ID: <CAC5umyg3MRWDupW=aeOsWZq00x30oK_S6wHwjw5zkjw46YFWUA@mail.gmail.com>
Subject: Re: [PATCH] fault-inject: Improve debug flexibility
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

2014-08-19 17:51 GMT+09:00 Dmitry Monakhov <dmonakhov@openvz.org>:
> Current debug levels are not optimal. Especially if one want to
> provoke big numbers of faults(broken device simulator) then any verbose
> level will produce giant numbers of identical logging messages. For that
> reason it is reasonable to have DUMP_ONCE flag, which will be cleared
> after first failure. Also the only way to understand which fail_attr
> was triggered is by means of investigating stack trace, which is also
> sub-optimal. Let's just dump name of this fail_attr.

Something like this feature looks very useful.  But instead of giving a
magic flag (1024) to existing 'verbose' parameter, I think creating new
parameter like 'verbose_ratelimit' is more useful.

        # dump only once in five seconds
        echo 5 > /sys/kernel/debug/fail_make_request/verbose_ratelimit

        # dump only once in a day
        echo $((24 * 60 * 60)) > \
                /sys/kernel/debug/fail_make_request/verbose_ratelimit
