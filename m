Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab3BHAfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:35:37 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33222 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3BHAff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:35:35 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20130207181706.GA8780@redhat.com>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org>
 <1358849741-9611-3-git-send-email-avagin@openvz.org> <20130207181706.GA8780@redhat.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 8 Feb 2013 01:35:14 +0100
Message-ID: <CAKgNAkjq3hVjYA3pVdBhyiFi1PbvXc_mOyvx_FaY67PmAifBOQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] signalfd: add ability to choose a private or shared queue
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 7:17 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> AOn 01/22, Andrey Vagin wrote:
>>
>> This patch is added two flags SFD_SHARED_QUEUE and SFD_PER_THREAD_QUEUE
>> SFD_SHARED_QUEUE
>
> I can't believe I am going to blame the naming ;) but these 2 do not look
> "symmetrical"....
>
> SFD_PRIVATE_QUEUE looks a little bit better to me. At least it is simpler
> to type. But I am fine either way.

At the risk of bikeshedding.... The point is that there are two
queues, the process-wide queue or the per-thread queue. "Private" does
not come into. And "Shared" is a little confusing. Adding those two
terms into the mix is just confusing: it doesn't fit with the
user-space view of signals.

I'd greatly prefer names that really say what these things are. Thus:

SFD_PROCESS_QUEUE + SFD_THREAD_QUEUE
or
SFD_PROCESS_WIDE_QUEUE + SFD_PER_THREAD_QUEUE
or
SFD_PROCESS_Q + SFD_THREAD_Q
or
[some consistent variation of the above]

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
