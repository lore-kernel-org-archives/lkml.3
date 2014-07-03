Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbaGCSyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:54:01 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:60195 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaGCSx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <53B5A343.4090402@linux.vnet.ibm.com>
References: <1404392547-11648-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
	<CA+55aFxOTqUAqEF7+83s890Q18qCHSQqDOxWqWHNjG_25hVhXg@mail.gmail.com>
	<53B59CB5.9060004@linux.vnet.ibm.com>
	<CA+55aFyRgYW6Y8paYKGfqE205enhiPsZ1C8wrKpFavVXq7ZAtA@mail.gmail.com>
	<CA+55aFwwSCrH5QDvrzzyHhRU5R849Mo8A3NdRMwm9OTeWH9diQ@mail.gmail.com>
	<53B5A343.4090402@linux.vnet.ibm.com>
Date: Thu, 3 Jul 2014 11:53:57 -0700
X-Google-Sender-Auth: 3wuyoZEiKVbE2tRqoLhkWgnfjcM
Message-ID: <CA+55aFyqK90YJkjtHR2QGFt4Mvn=mj8a4FkB_8nbTTj3=jp3NA@mail.gmail.com>
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

On Thu, Jul 3, 2014 at 11:38 AM, Raghavendra K T
<raghavendra.kt@linux.vnet.ibm.com> wrote:
>
> Okay, how about something like 256MB? I would be happy to send a patch
> for that change.

I'd like to see some performance numbers. I know at least Fedora uses
"readahead()" in the startup scripts, do we have any performance
numbers for that?

Also, I think 256MB is actually excessive. People still do have really
slow devices out there. USB-2 is still common, and drives that read at
15MB/s are not unusual. Do we really want to do readahead() that can
take tens of seconds (and *will* take tens of seconds sycnhronously,
because the IO requests fill up).

So I wouldn't go from 2 to 256. That seems like an excessive jump. I
was more thinking in the 4-8MB range. But even then, I think we should
always have technical reasons (ie preferably numbers) for the change,
not just randomly change it.

           Linus
