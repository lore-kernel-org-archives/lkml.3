Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaFCKN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:13:28 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:33947 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaFCKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <1401110850-3552-4-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
	<1401110850-3552-4-git-send-email-tixxdz@opendz.org>
Date: Tue, 3 Jun 2014 13:13:25 +0300
Message-ID: <CACVxJT_XxaHipdSb8X36=0GiP-_3ex0CrUFKDVm=aZS0LY+w4w@mail.gmail.com>
Subject: Re: [PATCH 3/9] procfs: add proc_read_from_buffer() and
 pid_entry_read() helpers
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 4:27 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> +/* 4K page size but our output routines use some slack for overruns */
> +#define PROC_BLOCK_SIZE        (3*1024)


This macro is the most ugly part of /proc, let's not dup it. :-)
Overruns simply should not happen.
