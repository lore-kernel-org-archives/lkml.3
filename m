Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaBYOQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:16:41 -0500
Received: from defer-dn03.ocn.ad.jp ([125.170.100.156]:48796 "EHLO
	defer-dn03.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaBYOQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:16:39 -0500
Date: Tue, 25 Feb 2014 22:55:28 +0900 (JST)
Message-Id: <20140225.225528.453119424.anemo@mba.ocn.ne.jp>
To: iivanov@mm-sol.com
Cc: broonie@kernel.org, gsi@denx.de, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] spi: core: Validate length of the transfers in
 message
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1392890528-7417-1-git-send-email-iivanov@mm-sol.com>
References: <1392890528-7417-1-git-send-email-iivanov@mm-sol.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 12:02:08 +0200, "Ivan T. Ivanov" <iivanov@mm-sol.com> wrote:
> SPI transfer length should be multiple of SPI word size,
> where SPI word size should be power-of-two multiple
...
> +		n_words = xfer->len / w_size;
> +		/* No partial transfers accepted */
> +		if (!n_words || xfer->len % w_size)
> +			return -EINVAL;

Is xfer->len == 0 invalid?
Long time ago I have fixed atmel spi driver to support zero length
transfer (commit 06719814 atmel_spi: support zero length transfer).

According to Documentation/spi/spi-summary, zeto length transfer seems
valid.

      + optionally defining short delays after transfers ... using
        the spi_transfer.delay_usecs setting (this delay can be the
        only protocol effect, if the buffer length is zero);

---
Atsushi Nemoto
