Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaFPXyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:54:41 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:43398 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaFPXyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:54:37 -0400
MIME-Version: 1.0
In-Reply-To: <1402955913-25036-1-git-send-email-davidriley@chromium.org>
References: <1402955913-25036-1-git-send-email-davidriley@chromium.org>
Date: Mon, 16 Jun 2014 16:54:36 -0700
Message-ID: <CALAqxLV97WEs501nduRoTanJ3SjW2J1mFQ_xdrE=nN2DOe11dQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] Add test to validate udelay
From: John Stultz <john.stultz@linaro.org>
To: David Riley <davidriley@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Doug Anderson <dianders@chromium.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the fixups. I've requeued these for 3.17.

thanks
-john

On Mon, Jun 16, 2014 at 2:58 PM, David Riley <davidriley@chromium.org> wrote:
> This change adds a module and a script that makes use of it to
> validate that udelay delays for at least as long as requested
> (as compared to ktime).
>
> Changes since v1:
> - allow udelay() to be 0.5% faster than requested as per feedback
>
> Changes since v2:
> - fix permissions on udelay_test.sh script
> - update commit message to indicate what this test targets
> - fixed checkpatch whitespace error
> - rebased
>
> Changes since v3:
> - fixed xtensa compile warning (and other 32-bit platforms which
>   use the generic do_div)
> - renamed and moved config option
>
> David Riley (2):
>   kernel: time: Add udelay_test module to validate udelay
>   tools: add script to test udelay
>
>  kernel/time/Makefile      |   1 +
>  kernel/time/udelay_test.c | 168 ++++++++++++++++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug         |   9 +++
>  tools/time/udelay_test.sh |  66 ++++++++++++++++++
>  4 files changed, 244 insertions(+)
>  create mode 100644 kernel/time/udelay_test.c
>  create mode 100755 tools/time/udelay_test.sh
>
> --
> 2.0.0
>
