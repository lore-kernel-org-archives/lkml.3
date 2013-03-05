Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab3CETHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:07:10 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:65527 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab3CETHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:07:08 -0500
MIME-Version: 1.0
In-Reply-To: <878v63mwm3.fsf_-_@xmission.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
 <20130303005700.GA32213@austin.hallyn.com> <874ngtxgt5.fsf@xmission.com>
 <CAGXu5j+bwUx6r++ttvYg4yJrUUHxoQ86tQ0JzEBoQQU6KAh9ww@mail.gmail.com>
 <874ngsrvrh.fsf@xmission.com> <CAGXu5jJiO=BmjVbpVJhxHbafn5T_SQbe5g-RLxRbmknNnQMyfQ@mail.gmail.com>
 <87k3pnmwpk.fsf_-_@xmission.com> <878v63mwm3.fsf_-_@xmission.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 5 Mar 2013 20:06:45 +0100
Message-ID: <CAPXgP11AB7=2oeXtxb0so4a8hms7-_UWJDVE=6kndU062tGycQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs: Limit sys_mount to only request filesystem modules.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@google.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, PaX Team <pageexec@freemail.hu>,
        linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 8:51 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
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

'-' is a commonly used part of a module name, and does not mix well
with ramdom user provided names.

We usually use ':' as the prefix separator for modaliases, when
user-supplied strings are prefixed with the subsystem.

I think it would be nicer to change that, and I'm sure some creative
guy calls the next filesystem of the month fs-$something :)

Kay
