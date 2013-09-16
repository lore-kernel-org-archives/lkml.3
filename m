Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3IPO7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:59:47 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:49247 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3IPO7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:59:43 -0400
MIME-Version: 1.0
In-Reply-To: <201309162041.HHG69783.FLFMJFtSOQOHVO@I-love.SAKURA.ne.jp>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	<1379317437-28329-2-git-send-email-keescook@chromium.org>
	<201309162041.HHG69783.FLFMJFtSOQOHVO@I-love.SAKURA.ne.jp>
Date: Mon, 16 Sep 2013 07:59:42 -0700
X-Google-Sender-Auth: 5wEVvUEpGzqZVt7MIZMuMMXf4P8
Message-ID: <CAGXu5jJErvcfdq0=QDd2pwCeK7kKnJ-GY2ybv9ssdkF6NjNvDw@mail.gmail.com>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Kees Cook <keescook@chromium.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        George Spelvin <linux@horizon.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Beulich <JBeulich@suse.com>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 4:41 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Kees Cook wrote:
>> -     seq_printf(m, "%s%d%n", con->name, con->index, &len);
>> -     len = 21 - len;
>> +     len = m->count;
>> +     seq_printf(m, "%s%d", con->name, con->index);
>> +     len = 21 - (m->count - len);
>
> Why not to create a new function which returns bytes written?
> The new function does not need to return negative value for indicating errors.

I think it's not worth it for two reasons:

- there are very few callers that need this logic
- it would require a new function for each type of function used
(right now both seq_printf and seq_puts are used).

Perhaps instead of seq->count, there should be an access function?
seq_get_count(seq) or something?

-Kees

-- 
Kees Cook
Chrome OS Security
