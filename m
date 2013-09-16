Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3IPPAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:00:53 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:57354 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab3IPPAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUw7J6TmQ=13_zoC=rvGy0PZwd8VF5t3g8pjPQX5WaVUg@mail.gmail.com>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	<1379317437-28329-2-git-send-email-keescook@chromium.org>
	<CAMuHMdUw7J6TmQ=13_zoC=rvGy0PZwd8VF5t3g8pjPQX5WaVUg@mail.gmail.com>
Date: Mon, 16 Sep 2013 08:00:50 -0700
X-Google-Sender-Auth: cxLK-YEaUSNGKCv4YUe0ZeKWwpc
Message-ID: <CAGXu5j+f_vTknA0KCROUh3CY5spc8pE0_SxJ2uwqQhfFpuSmXQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Kees Cook <keescook@chromium.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, George Spelvin <linux@horizon.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Beulich <JBeulich@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 1:09 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, Sep 16, 2013 at 9:43 AM, Kees Cook <keescook@chromium.org> wrote:
>> All users of %n are calculating padding size when using seq_file, so
>> instead use the new last_len member for discovering the length of the
>> written strings.
>
> Would it make sense to provide a seq_pad(...) function instead, to avoid
> exposing more seq_file internals to its callers?

We'd still need to track how much to pad.

-Kees

-- 
Kees Cook
Chrome OS Security
