Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab3HNT0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:26:31 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63534 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107Ab3HNT01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:26:27 -0400
Message-ID: <520BD9E0.8050304@mit.edu>
Date: Wed, 14 Aug 2013 12:26:24 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: DoS with unprivileged mounts
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
In-Reply-To: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 10:42 AM, Miklos Szeredi wrote:
> There's a simple and effective way to prevent unlink(2) and rename(2)
> from operating on any file or directory by simply mounting something
> on it.  In any mount instance in any namespace.
> 
> Was this considered in the unprivileged mount design?
> 
> The solution is also theoretically simple: mounts in unpriv namespaces
> are marked "volatile" and are dissolved on an unlink type operation.

I'd actually prefer the reverse: unprivileged mounts don't prevent
unlink and rename.  If the dentry goes away, then the mount could still
exist, sans underlying file.  (This is already supported on network
filesystems.)

--Andy
