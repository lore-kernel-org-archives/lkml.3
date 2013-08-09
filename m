Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031Ab3HIPYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934350Ab3HIPYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:24:40 -0400
Date: Fri, 9 Aug 2013 17:18:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Cc: Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/1] dlm: kill the unnecessary and wrong
	device_close()->recalc_sigpending()
Message-ID: <20130809151852.GA4619@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com> <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com> <20130808191749.GA12062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808191749.GA12062@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08, Oleg Nesterov wrote:
>
> And of course, there could be another bug. I just did
> "grep recalc_sigpending" and immediately found at least one buggy
> user, fs/dlm/user.c which calls it lockless.

and the usage of sigprocmask() is wrong, see 1/1.

In fact there are more users which play with sigprocmask() this way.
I am starting to think that, perhaps, we should implement some helpers
for this use-case.

Oleg.

