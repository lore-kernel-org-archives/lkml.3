Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3CCSaP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 13:30:15 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:42066 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab3CCSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 13:30:13 -0500
MIME-Version: 1.0
In-Reply-To: <87vc98x019.fsf_-_@xmission.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<CAGXu5jLciqXcuhzDVPKPqA+mwv8e28zGAMScatzov3U07BuBaQ@mail.gmail.com>
	<20130303035608.GA2703@austin.hallyn.com>
	<87vc98x019.fsf_-_@xmission.com>
Date: Sun, 3 Mar 2013 10:30:12 -0800
Message-ID: <CAGXu5jKSp8ceMkDYS6acxEqiJ9Hkz=S9oYiTGqCLe8M=ZAmpng@mail.gmail.com>
Subject: Re: [RFC][PATCH] fs: Limit sys_mount to only loading filesystem modules.
From: Kees Cook <keescook@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 2:14 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Modify the request_module to prefix the file system type with "fs-"
> and add aliases to all of the filesystems that can be built as modules
> to match.
>
> A common practice is to build all of the kernel code and leave code
> that is not commonly needed as modules, with the result that many
> users are exposed to any bug anywhere in the kernel.
>
> Looking for filesystems with a fs- prefix limits the pool of possible
> modules that can be loaded by mount to just filesystems trivially
> making things safer with no real cost.
>
> Using aliases means user space can control the policy of which
> filesystem modules are auto-loaded by editing /etc/modprobe.d/*.conf
> with blacklist and alias directives.  Allowing simple, safe,
> well understood work-arounds to known problematic software.
>
> This also addresses a rare but unfortunate problem where the filesystem
> name is not the same as it's module name and module auto-loading
> would not work.  While writing this patch I saw a handful of such
> cases.  The most significant being autofs that lives in the module
> autofs4.
>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
