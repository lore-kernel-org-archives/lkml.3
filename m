Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3IQOew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:34:52 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:62425 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3IQOeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:34:50 -0400
MIME-Version: 1.0
In-Reply-To: <201309172206.FGE12970.FQFtOSMJOVHOFL@I-love.SAKURA.ne.jp>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	<1379317437-28329-2-git-send-email-keescook@chromium.org>
	<CAMuHMdUw7J6TmQ=13_zoC=rvGy0PZwd8VF5t3g8pjPQX5WaVUg@mail.gmail.com>
	<CAGXu5j+f_vTknA0KCROUh3CY5spc8pE0_SxJ2uwqQhfFpuSmXQ@mail.gmail.com>
	<201309172206.FGE12970.FQFtOSMJOVHOFL@I-love.SAKURA.ne.jp>
Date: Tue, 17 Sep 2013 07:34:50 -0700
X-Google-Sender-Auth: XDWN_pAa_zE65r1FUUO21fr7Qys
Message-ID: <CAGXu5jL+NeBw2_vXymM81UdtS6UO7KZA2S4rf3gwM_7nSJ2h6g@mail.gmail.com>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Kees Cook <keescook@chromium.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        George Spelvin <linux@horizon.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Beulich <JBeulich@suse.com>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 6:06 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Kees Cook wrote:
>> On Mon, Sep 16, 2013 at 1:09 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > On Mon, Sep 16, 2013 at 9:43 AM, Kees Cook <keescook@chromium.org> wrote:
>> >> All users of %n are calculating padding size when using seq_file, so
>> >> instead use the new last_len member for discovering the length of the
>> >> written strings.
>> >
>> > Would it make sense to provide a seq_pad(...) function instead, to avoid
>> > exposing more seq_file internals to its callers?
>>
>> We'd still need to track how much to pad.
>
> If we add "size_t pad_until;" to "struct seq_file", we can do
>
> void seq_setwidth(struct seq_file *m, size_t size)
> {
>         m->pad_until = m->count + size;
> }
>
> void seq_pad(struct seq_file *m, char c)
> {
>         int size = m->pad_until - m->count;
>         if (size > 0)
>                 seq_printf(m, "%*s", size, "");
>         if (c)
>                 seq_putc(m, c);
> }
>
> and use like
>
>   seq_setwidth(m, 21);
>   seq_printf(m, "%s%d", con->name, con->index);
>   seq_pad(m, '\n');

Ooh, I like this a lot! Much cleaner.

-Kees

-- 
Kees Cook
Chrome OS Security
