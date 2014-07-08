Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaGHMsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:48:51 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:59965 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaGHMst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140708120702.GB30459@infradead.org>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com> <CALCETrU=HLmw9n-DxPkFV1xP5wtzQ7-YF3-uao6YiGZODA9kdw@mail.gmail.com>
 <20140630154928.GB10375@google.com> <CALCETrWJ-rqDo8OvSZWPUt1806gObNtwVHvC4M6kfQgvd3Eg9w@mail.gmail.com>
 <20140708120702.GB30459@infradead.org>
From: Meredydd Luff <meredydd@senatehouse.org>
Date: Tue, 8 Jul 2014 13:48:27 +0100
Message-ID: <CAD=T17FQEZV+iy91wQAvAdd0PW2tsfjpU7atp-xeatm5sEGz5Q@mail.gmail.com>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        David Drysdale <drysdale@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-man@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 July 2014 13:07, Christoph Hellwig <hch@infradead.org> wrote:
> There's two different AT_* namespaces.  The flags that most *at syscalls
> has, and the the one for the dfd argument, which currently only contains
> AT_FDCWD, although a new constant has recently been proposed to it.
>
> Having an AT_BENEATH magic value for the dfd argument certainly feels
> elegant to me

How would that work? The directory beneath which openat is looking is
conveyed in the dfd argument itself. If I'm understanding this right,
you'd have to pass a different value for "open relative to fd#5" and
"open relative to fd#5, but beneath it only", which doesn't sound
hugely elegant to me.

Meredydd
