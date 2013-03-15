Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab3COPYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:24:31 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:61289 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab3COPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <514319D4.6050200@tycho.nsa.gov>
References: <CABhRnsWdD6Ef1kg=bud7RKpsQ7KeUhuQEw4Z2N_0RePgS=QDGg@mail.gmail.com>
 <514319D4.6050200@tycho.nsa.gov>
From: Thomas COUDRAY <amanone@gmail.com>
Date: Fri, 15 Mar 2013 16:24:05 +0100
Message-ID: <CABhRnsXJ6RJ1wPDy_Z3cHmx8q9zdOHDRi5cxt-PFMKcYVv7xpA@mail.gmail.com>
Subject: Re: lgetxattr()/getxattr() return different values on a file labelled
 with selinux disabled
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: jmorris@namei.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/15 Stephen Smalley <sds@tycho.nsa.gov>:
> f is truly a regular file and not a symlink pointing to a regular file?

f is a truly regular file.

> before_t and after_t are both defined in the policy?

Only before_t was defined in the policy.
When I define after_t in the policy, both commands return the same
label (after_t).
But I wouldn't expect this to make a difference in the output of both
commands (as the only visible difference is lgetxattr() vs getxattr())

> before_t and after_t are not type aliases of each other?

They are not.

> What are the credentials (capabilities and SELinux security
> context/permissions) of the process running the ls and getfattr commands?

It has unconfined_u:unconfined_r:before_t label with before_t type.
Same as the file f.
The process has full SELinux rights on both command and file.

> Any relevant messages from SELinux in dmesg output?

No avc warnings in dmesg and audit.log. All looks good.

--
Thomas Coudray
