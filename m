Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab3JDX1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 19:27:37 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47405 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3JDX1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 19:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <20131003185630.GJ13318@ZenIV.linux.org.uk>
References: <20131001145755.GA22729@redhat.com>
	<20131003185630.GJ13318@ZenIV.linux.org.uk>
Date: Fri, 4 Oct 2013 16:27:35 -0700
X-Google-Sender-Auth: sQYymoqVOx6TcVAM7e2_8goeem4
Message-ID: <CA+55aFxEs=bdtw-SPRSnVz7bGE3Pyi+tM7wsEdwxu+GL5qq5_Q@mail.gmail.com>
Subject: Re: pipe/cred lockdep warning
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 11:56 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Note, BTW, that splice to /proc/<pid>/attr/<something> is broken.
> proc_pid_attr_write() is *not* supposed to allow partial writes at all.
> Frankly, I'd consider adding a ->splice_write() instance that would
> simply return -EINVAL there...

That sounds like the right thing to do.

Or possibly go even further, and say that the default is to return
-EINVAL, and files and filesystems that actually want the
"default_file_splice_write()" semantics have to say so in their d_op
structure.

Hmm?

               Linus
