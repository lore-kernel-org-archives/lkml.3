Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaF3OuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:50:06 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63555 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaF3OuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:50:03 -0400
MIME-Version: 1.0
In-Reply-To: <1404124096-21445-2-git-send-email-drysdale@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com> <1404124096-21445-2-git-send-email-drysdale@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jun 2014 07:49:41 -0700
Message-ID: <CALCETrU=HLmw9n-DxPkFV1xP5wtzQ7-YF3-uao6YiGZODA9kdw@mail.gmail.com>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
To: David Drysdale <drysdale@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 30, 2014 3:36 AM, "David Drysdale" <drysdale@google.com> wrote:
>
> Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
> provided path, rejecting (with -EACCES) paths that are not beneath
> the provided dfd.  In particular, reject:
>  - paths that contain .. components
>  - paths that begin with /
>  - symlinks that have paths as above.

I like this a lot.  However, I think I'd like it even better if it
were AT_BENEATH_ONLY so that it could be added to the rest of the *at
family.

--Andy
