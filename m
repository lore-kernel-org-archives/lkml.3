Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaF3VMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:12:13 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:50295 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaF3VML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:12:11 -0400
MIME-Version: 1.0
In-Reply-To: <87mwcuw2pj.fsf@tassilo.jf.intel.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com> <87mwcuw2pj.fsf@tassilo.jf.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jun 2014 14:11:49 -0700
Message-ID: <CALCETrUXgkiNf+pCKL5dyAFRbm4dF4R-E=qf6CzpV5pnsdrBkQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
To: Andi Kleen <andi@firstfloor.org>
Cc: David Drysdale <drysdale@google.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 1:40 PM, Andi Kleen <andi@firstfloor.org> wrote:
> David Drysdale <drysdale@google.com> writes:
>
>> Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
>> provided path, rejecting (with -EACCES) paths that are not beneath
>> the provided dfd.  In particular, reject:
>>  - paths that contain .. components
>>  - paths that begin with /
>>  - symlinks that have paths as above.
>
> How about bind mounts?

What's the problematic scenario?

--Andy
