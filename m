Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3FGJTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:19:09 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58695 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab3FGJTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:19:07 -0400
MIME-Version: 1.0
In-Reply-To: <1370595083-801-1-git-send-email-christian.ruppert@abilis.com>
References: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
	<1370595083-801-1-git-send-email-christian.ruppert@abilis.com>
Date: Fri, 7 Jun 2013 12:19:05 +0300
Message-ID: <CAHp75VfwSTO7UoEGVpd7qdFVSFNYrBG6aXx1Oj8UAkgbmi=1XQ@mail.gmail.com>
Subject: Re: [PATCH V2] i2c: designware: fix race between subsequent xfers
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 11:51 AM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:
> The designware block is not always properly disabled in the case of
> transfer errors. Interrupts from aborted transfers might be handled
> after the data structures for the following transfer are initialised but
> before the hardware is set up. This can corrupt the data structures to
> the point that the system is stuck in an infinite interrupt loop (where
> FIFOs are never emptied because dev->msg_read_idx == dev->msgs_num).
>
> This patch cleanly disables the designware-i2c hardware at the end of
> every transfer, be it successful or not.
>
> This patch requires https://patchwork.kernel.org/patch/2601241/ to be
> applied first.

What if you just move disabling code from i2c_dw_xfer_init() to the
top of i2c_dw_xfer() ?
Will it help?

--
With Best Regards,
Andy Shevchenko
