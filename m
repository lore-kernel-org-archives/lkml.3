Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3BZRBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:01:47 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56571 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3BZRBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:01:45 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <512CE75A.5080203@oracle.com>
References: <512CE75A.5080203@oracle.com>
Date: Tue, 26 Feb 2013 18:01:44 +0100
Message-ID: <CA+icZUUp-w5vOxXc4aXuvwRMUX_f4jzrPubBLav=eamd8ZcTuw@mail.gmail.com>
Subject: Re: fs: WARNING: at fs/dcache.c:2587 prepend_path
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 5:48 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running latest -next,
> I've started seeing a bunch of these, which wasn't there in the -next from
> couple of days ago:
>
> [ 1169.020539] ------------[ cut here ]------------
> [ 1169.021297] WARNING: at fs/dcache.c:2587 prepend_path+0x188/0x1f0()
> [ 1169.022903] Root dentry has weird name <dev/zero>
> [ 1169.023967] Modules linked in:
> [ 1169.024479] Pid: 28818, comm: trinity Tainted: G        W    3.8.0-next-20130225-sasha-00042-g8547837 #997
> [ 1169.026771] Call Trace:
> [ 1169.027527]  [<ffffffff8110cd1c>] warn_slowpath_common+0x8c/0xc0
> [ 1169.028442]  [<ffffffff8110cdf1>] warn_slowpath_fmt+0x41/0x50
> [ 1169.029829]  [<ffffffff81147a10>] ? lg_local_lock+0x70/0x80
> [ 1169.031038]  [<ffffffff8129e0da>] ? prepend_path+0x3a/0x1f0
> [ 1169.032783]  [<ffffffff8129e228>] prepend_path+0x188/0x1f0
> [ 1169.034083]  [<ffffffff8129f0e1>] d_path+0x101/0x140
> [ 1169.034946]  [<ffffffff812ad5ae>] seq_path+0x5e/0xd0
> [ 1169.035804]  [<ffffffff812f7494>] show_map_vma+0x174/0x2b0
> [ 1169.037065]  [<ffffffff812f75fa>] show_map+0x2a/0x60
> [ 1169.037790]  [<ffffffff812f764e>] show_pid_map+0xe/0x10
> [ 1169.038902]  [<ffffffff812adf31>] seq_read+0x311/0x430
> [ 1169.039944]  [<ffffffff81287e23>] vfs_read+0xb3/0x120
> [ 1169.040934]  [<ffffffff8118554d>] ? trace_hardirqs_on+0xd/0x10
> [ 1169.042842]  [<ffffffff812885dd>] sys_read+0x5d/0xa0
> [ 1169.043696]  [<ffffffff84025290>] tracesys+0xdd/0xe2
> [ 1169.045019] ---[ end trace 6e68f4c39bb079ca ]---
>
>

Known issue, please see below link...

http://marc.info/?l=linux-next&m=136187065814300&w=2

> Thanks,
> Sasha
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
