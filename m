Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3HCTKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 15:10:11 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:42640 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3HCTKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 15:10:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130801190516.GA3223@redhat.com>
References: <20130801190455.GA3194@redhat.com>
	<20130801190516.GA3223@redhat.com>
Date: Sat, 3 Aug 2013 12:10:09 -0700
X-Google-Sender-Auth: A4DYgNru4Rd9cxG1GH6_WlksELg
Message-ID: <CAGXu5jJjNMFKNE8+q31xSMxnqVFHB2KhjSgyWn03MpiLy0X0Ng@mail.gmail.com>
Subject: Re: [PATCH 3/3] exec: proc_exec_connector() should be called only once
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 12:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> A separate one-liner with the minor fix.
>
> PROC_EVENT_EXEC reports the "exec" event, but this message
> is sent at least twice if search_binary_handler() is called
> by ->load_binary() recursively, say, load_script().
>
> Move it to exec_binprm(), this is "depth == 0" code too.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Yeah, looks right. I almost mentioned this while reading the other
cleanup patch, but then you fixed it too. :)

Acked-by: Kees Cook <keescook@chromium.org>

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
