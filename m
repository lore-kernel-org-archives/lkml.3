Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149Ab3IPPZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:25:46 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:33448 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3IPPZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:25:45 -0400
MIME-Version: 1.0
In-Reply-To: <1379344187.1934.1.camel@joe-AO722>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	<1379317437-28329-2-git-send-email-keescook@chromium.org>
	<201309162041.HHG69783.FLFMJFtSOQOHVO@I-love.SAKURA.ne.jp>
	<CAGXu5jJErvcfdq0=QDd2pwCeK7kKnJ-GY2ybv9ssdkF6NjNvDw@mail.gmail.com>
	<1379344187.1934.1.camel@joe-AO722>
Date: Mon, 16 Sep 2013 08:25:44 -0700
X-Google-Sender-Auth: MmRXkW9D5jOuc0VXS4RXNEcu0xs
Message-ID: <CAGXu5jK7ALtFq74duH_ymoLnmoHKYmty+60HCG3YFyhghi2Scg@mail.gmail.com>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>,
        George Spelvin <linux@horizon.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Beulich <JBeulich@suse.com>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 8:09 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2013-09-16 at 07:59 -0700, Kees Cook wrote:
>> Perhaps instead of seq->count, there should be an access function?
>> seq_get_count(seq) or something?
>
> My thought was to add a seq_last_len()

That would mean growing the size of the seq_file structure and adding
instructions for all users. While I personally have no problem with
that, I worry others might. If we just use seq->count (or equivalent
function), then only those that want length will use it. I actually
think this uses fewer instructions than %n. Especially in the case
where seq_printf got replaced by seq_puts. :)

-Kees

-- 
Kees Cook
Chrome OS Security
