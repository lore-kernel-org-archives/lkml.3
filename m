Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab3BYUd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:33:56 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab3BYUdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:33:53 -0500
Message-ID: <512BCA9E.4090702@nod.at>
Date: Mon, 25 Feb 2013 21:33:34 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: ocfs2-devel@oss.oracle.com
CC: ocfs2-user@oss.oracle.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, mfasheh@suse.com, jlbec@evilplan.org,
        linux-fsdevel@vger.kernel.org, david@sigma-star.at
Subject: OCFS2 mainline state?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Today I encountered the following problem on v3.8:
[   28.940032] general protection fault: 0000 [#1] PREEMPT SMP
...
[   28.984953] Call Trace:
[   28.986628   [<ffffffffa04cb200>] ocfs2_fast_symlink_readpage+0x70/0x1b0 [ocfs2]
[   28.988302]  [<ffffffff8110dc49>] ? add_to_page_cache_lru+0x29/0x40
[   28.989942]  [<ffffffff8110ddca>] do_read_cache_page+0x7a/0x170
[   28.991573]  [<ffffffff8110def4>] read_cache_page_async+0x14/0x20
[   28.993212]  [<ffffffff8110df09>] read_cache_page+0x9/0x20
[   28.994827]  [<ffffffff81170ae5>] page_getlink.isra.9+0x25/0x80
[   28.996442]  [<ffffffff81170b61>] page_follow_link_light+0x21/0x40
[   28.998049]  [<ffffffff8117090d>] generic_readlink+0x3d/0xa0
[   28.999653]  [<ffffffff8116c0db>] sys_readlinkat+0xfb/0x130
[   29.001246]  [<ffffffff8116c126>] sys_readlink+0x16/0x20
[   29.002839]  [<ffffffff815d8dad>] system_call_fastpath+0x1a/0x1f

To my utter astonishment I found out that the issue is known since August 2012.
And there is also a trivial fix for it.[0]
The said fix found it's way into Oracle Unbreakable Linux very quickly,
but not into mainline.[1]

Now I'm wondering how much Oracle really cares about OCFS2 in mainline?
Maybe there are some more unfixed vulnerabilities?

Not amused,
//richard

[0] http://www.mail-archive.com/ocfs2-devel@oss.oracle.com/msg07774.html
[1] https://oss.oracle.com/pipermail/el-errata/2012-October/003103.html
