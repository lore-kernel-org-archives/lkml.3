Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3LTL3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:29:54 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:51133 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3LTL3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:29:52 -0500
MIME-Version: 1.0
In-Reply-To: <20131220094134.24233.2969.stgit@yunodevel>
References: <20131220094134.24233.2969.stgit@yunodevel>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 20 Dec 2013 12:29:29 +0100
Message-ID: <CAPXgP11H7EB5Sfezf_7NkKzXT4n4EnPPyE2wWV9YQmR=3LsbAw@mail.gmail.com>
Subject: Re: [PATCH 0/2] [BUGFIX] printk: Fix message continuation breakage
 involved with structured printk
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 10:41 AM, Yoshihiro YUNOMAE
<yoshihiro.yunomae.ez@hitachi.com> wrote:

> This patch set fixes message continuation breakage involved with structured
> printk. A SCSI driver may output two continuation error messages like
>     scmd_printk("foo");
>     printf("bar\n");

Which is the absolutely wrong thing to do. Structured logging and racy
printk continuation must never be mixed. Userspace needs to be sure
that dictionary entries are not subject to racy continuation hackery,
and that these mwssages atomic, whole and intact.

Please do not mix the both and do not apply these patches.

Thanks,
Kay
