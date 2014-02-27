Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaB0Nil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:38:41 -0500
Received: from mv-drv-hcb003.ocn.ad.jp ([118.23.109.133]:33889 "EHLO
	mv-drv-hcb003.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbaB0Nii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:38:38 -0500
X-Greylist: delayed 171787 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 08:38:38 EST
Date: Thu, 27 Feb 2014 22:38:26 +0900 (JST)
Message-Id: <20140227.223826.522636360.anemo@mba.ocn.ne.jp>
To: broonie@kernel.org
Cc: iivanov@mm-sol.com, gsi@denx.de, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] spi: core: Validate length of the transfers in
 message
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20140226001407.GM2927@sirena.org.uk>
References: <1392890528-7417-1-git-send-email-iivanov@mm-sol.com>
	<20140225.225528.453119424.anemo@mba.ocn.ne.jp>
	<20140226001407.GM2927@sirena.org.uk>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 09:14:07 +0900, Mark Brown <broonie@kernel.org> wrote:
>>       + optionally defining short delays after transfers ... using
>>         the spi_transfer.delay_usecs setting (this delay can be the
>>         only protocol effect, if the buffer length is zero);
> 
> *sigh*  I guess it is valid, though frankly I'm concerned that this
> isn't a good idea - it's certainly not going to work reliably given the
> need for every driver to open code this, most of them get the delay
> stuff wrong.

I don't object to the whole patch.  Validating in spi core is good of
course, and "xfer->len % w_size" part looks no problem.

I just want to keep ways to handle an odd device, for example, which
requires long delay between chipselect and the first transfer, etc.

---
Atsushi Nemoto
