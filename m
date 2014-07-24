Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163AbaGXSd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:33:26 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52090 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063AbaGXSdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:33:24 -0400
MIME-Version: 1.0
In-Reply-To: <53D14E60.1010105@gmx.de>
References: <53D14E60.1010105@gmx.de>
Date: Thu, 24 Jul 2014 22:33:23 +0400
Message-ID: <CALFYKtAyB6xGEgJ65Ti5vPx9xf4ipX9__FZBwosBYg1y9z7cKg@mail.gmail.com>
Subject: Re: sizeof (struct tYpO *) : it is just a typo or rather a bug ?
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-ia64@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 10:20 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> Inspired by this "typo" fix
> http://article.gmane.org/gmane.linux.kernel/1754640
> I grep'ed the current git tree of linus for similar issues.
>
> For these 4 places I'm wondering where the appropriate struct definition is located :
>
> arch/ia64/sn/kernel/io_acpi_init.c:         sizeof(struct pci_devdev_info *)) {
> tools/perf/builtin-sched.c:     sched->tasks = realloc(sched->tasks, sched->nr_tasks * sizeof(struct task_task *));
> fs/ceph/xattr.c:                xattrs = kcalloc(numattr, sizeof(struct ceph_xattr *),
> fs/ceph/xattr.c:                memset(xattrs, 0, numattr*sizeof(struct ceph_xattr *));

Heh, the ceph one is a five year old typo..  Looks like it should be
struct ceph_inode_xattr, I'll fix it up.  I'm curious though, how did
you grep for these?

Thanks,

                Ilya
