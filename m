Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaBRXDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:03:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbaBRXDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:03:47 -0500
Date: Tue, 18 Feb 2014 15:03:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wang YanQing <udknight@gmail.com>
Cc: ebiederm@xmission.com, serge.hallyn@canonical.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] kernel/groups.c: remove return value of set_groups
Message-Id: <20140218150346.ea6fc4fdb99ab24a4d77373f@linux-foundation.org>
In-Reply-To: <20140216153107.GA3622@udknight>
References: <20140216153107.GA3622@udknight>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Feb 2014 23:31:07 +0800 Wang YanQing <udknight@gmail.com> wrote:

> After commit 6307f8fee295b364716d28686df6e69c2fee751a
> ("security: remove dead hook task_setgroups"), set_groups
> will always return zero, so we could just remove return
> value of set_groups.
> 
> This patch reduce code size, and simplfy code logician
> to use set_groups, because we don't need to check its
> return value anymore.
> 

Looks OK.  We should also update the set_groups() description to
reflect reality.

--- a/kernel/groups.c~kernel-groupsc-remove-return-value-of-set_groups-fix
+++ a/kernel/groups.c
@@ -157,9 +157,6 @@ int groups_search(const struct group_inf
  * set_groups - Change a group subscription in a set of credentials
  * @new: The newly prepared set of credentials to alter
  * @group_info: The group list to install
- *
- * Validate a group subscription and, if valid, insert it into a set
- * of credentials.
  */
 void set_groups(struct cred *new, struct group_info *group_info)
 {
_

