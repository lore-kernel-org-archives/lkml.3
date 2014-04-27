Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaD0S2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 14:28:11 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48905 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbaD0S2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 14:28:09 -0400
Subject: Re: [PATCH 00/47] Lustre fixes and cleanups
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=utf-8
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140427173331.GA11038@kroah.com>
Date: Sun, 27 Apr 2014 14:28:00 -0400
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Transfer-Encoding: 8BIT
Message-Id: <272959FB-A014-4E8B-A04E-2BDF63FE8BB1@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru> <20140427173331.GA11038@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Apr 27, 2014, at 1:33 PM, Greg Kroah-Hartman wrote:
> I've applied these, except for the 3 gss patches.

Thanks.

gss stuff was kind of totally separate, tso I thought it was not so bad idea  to include them,
but they are definitely not required.

> Also, there is now a build warning in the tree thanks to these, please
> send a follow-on patch to fix it before you get an email from the 0-day
> bot about it.

This one? I was under impression it was there before the pile of the patches as lustre/llite/symlink.c was last touched back in March and none of my patches touch it.
I'll have a patch for it shortly.

In file included from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/linux/lustre_compat25.h:41:0,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/linux/lvfs.h:48,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/lvfs.h:45,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/obd_support.h:41,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/obd_class.h:40,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/linux/lustre_lite.h:49,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/lustre_lite.h:45,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/symlink.c:42:
/home/green/bk/linux/drivers/staging/lustre/lustre/llite/symlink.c: In function Б─≤ll_follow_linkБ─≥:
/home/green/bk/linux/include/linux/namei.h:88:29: warning: Б─≤symnameБ─≥ may be used uninitialized in this function [-Wmaybe-uninitialized]
  nd->saved_names[nd->depth] = path;
                             ^
/home/green/bk/linux/drivers/staging/lustre/lustre/llite/symlink.c:123:8: note: Б─≤symnameБ─≥ was declared here
  char *symname;
        ^

Bye,
    Oleg