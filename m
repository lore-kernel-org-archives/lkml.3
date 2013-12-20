Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195Ab3LTLga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:36:30 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48421 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030181Ab3LTLg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:36:29 -0500
MIME-Version: 1.0
In-Reply-To: <20131220094139.24233.9630.stgit@yunodevel>
References: <20131220094134.24233.2969.stgit@yunodevel> <20131220094139.24233.9630.stgit@yunodevel>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 20 Dec 2013 12:36:08 +0100
Message-ID: <CAPXgP12dLpz=gUOAox5BxHU2nq0a6eJyvNSUpaTmR5Z+k-EzwQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] printk: Delete LOG_NEWLINE flag for structured printk
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
> Delete LOG_NEWLINE flag for structured printk.
> When structured printk is used, the next printk message is output in a new line
> from patch c313af145b9bc4fb8e8e0c83b8cfc10e1b894a50. However, in a following
> pseudo SCSI error test, the device information and the detail information are
> divided:

This is wrong. Please do not apply. Racy ontinuation lines and
strutured logging should not be mixed. Continuation lines are a nice
kernel hack for debugging, useful to have, but cannot be trusted by
userspace. The entire purpose of structured logging is to have
trustable atomic logging messages, the both facilities should not be
mixed.

Thanks,
Kay
