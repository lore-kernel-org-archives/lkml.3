Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbaGCPmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:42:01 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:40238 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786AbaGCPl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <1404392547-11648-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1404392547-11648-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Date: Thu, 3 Jul 2014 08:41:58 -0700
X-Google-Sender-Auth: 2dUmddIb-ZHdf3CoaYFWMfBfEz4
Message-ID: <CA+55aFxOTqUAqEF7+83s890Q18qCHSQqDOxWqWHNjG_25hVhXg@mail.gmail.com>
Subject: Re: [PATCH] mm readahead: Fix sys_readahead breakage by reverting 2MB
 limit (bug 79111)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 6:02 AM, Raghavendra K T
<raghavendra.kt@linux.vnet.ibm.com> wrote:
>
> However it broke sys_readahead semantics: 'readahead() blocks until the specified
> data has been read'

What? Where did you find that insane sentence? And where did you find
an application that depends on that totally insane semantics that sure
as hell was never intentional.

If this comes from some man-page, then the man-page is just full of
sh*t, and is being crazy. The whole and *only* point of readahead() is
that it does *not* block, and you can do it across multiple files.

So NAK NAK NAK. This is insane and completely wrong. And the bugzilla
is crazy too. Why would anybody think that readahead() is the same as
read()?

             Linus
