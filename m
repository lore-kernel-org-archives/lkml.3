Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3HOVXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:23:49 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:64424 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3HOVXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:23:47 -0400
Date: Thu, 15 Aug 2013 16:23:45 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: DoS with unprivileged mounts
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
In-Reply-To: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	(from miklos@szeredi.hu on Wed Aug 14 12:42:19 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1376601825.2737.37@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 12:42:19 PM, Miklos Szeredi wrote:
> There's a simple and effective way to prevent unlink(2) and rename(2)
> from operating on any file or directory by simply mounting something
> on it.  In any mount instance in any namespace.
> 
> Was this considered in the unprivileged mount design?
> 
> The solution is also theoretically simple: mounts in unpriv namespaces
> are marked "volatile" and are dissolved on an unlink type operation.
> 
> Such volatile mounts would be useful in general too.

Would that "anonymous inode" thing that wandered by recently help,  
letting umount move the mount to one side so you could keep the mount  
point as the root of your per-process hierarchy but not have it glued  
to other people's namespaces?

Rob