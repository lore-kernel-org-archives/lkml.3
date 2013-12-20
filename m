Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3LTLdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:33:16 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58841 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab3LTLdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:33:14 -0500
MIME-Version: 1.0
In-Reply-To: <20131220094137.24233.46216.stgit@yunodevel>
References: <20131220094134.24233.2969.stgit@yunodevel> <20131220094137.24233.46216.stgit@yunodevel>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 20 Dec 2013 12:32:53 +0100
Message-ID: <CAPXgP109xPWxLLhTmzj_EcEnm0sT+M++iRTrHLnpa6tRRdxNSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] printk: Add dictionary information in structure cont
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
> Add dictionary information in structure cont.
> Dictionary information is added when a driver uses structured printk, and the
> information is shown in /dev/kmsg. Current kernel directly stores the
> information to log_buf. This patch stores the dict information in structure cont
> first, then the information in cont is stored to log_buf.
>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: linux-kernel@vger.kernel.org

This is wrong. Please do not apply. Racy ontinuation lines and
strutured logging should not be mixed. Continuation lines are a nice
kernel hack for debugging, useful to have, but cannot be trusted by
userspace. The entire purpose of structured logging is to have
trustable atomic logging messages, the both facilities should not be
mixed.

Thanks,
Kay
