Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab3HNRmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:42:22 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46399 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368Ab3HNRmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:42:20 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
Date: Wed, 14 Aug 2013 19:42:19 +0200
Message-ID: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
Subject: DoS with unprivileged mounts
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a simple and effective way to prevent unlink(2) and rename(2)
from operating on any file or directory by simply mounting something
on it.  In any mount instance in any namespace.

Was this considered in the unprivileged mount design?

The solution is also theoretically simple: mounts in unpriv namespaces
are marked "volatile" and are dissolved on an unlink type operation.

Such volatile mounts would be useful in general too.

Thanks,
Miklos
