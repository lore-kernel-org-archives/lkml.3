Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3J1QGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:06:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33327 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab3J1QG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:06:26 -0400
X-Sasl-enc: PbG64rkZw/XIF1EEA2w6+QYqSrl9IhCuhDaWhOKj5CLK 1382976385
Date: Mon, 28 Oct 2013 14:06:23 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131028160623.GD15440@khazad-dum.debian.net>
References: <2579337.FPgJGgHYdz@tauon>
 <2049321.gMV6JUDze7@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2049321.gMV6JUDze7@tauon>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013, Stephan Mueller wrote:
> If it is accepted that the CPU Jitter RNG delivers entropy, the latter 
> update may now allow us to get rid of storing the seed file during 
> shutdown and restoring it during the next boot sequence.

That's a 4096-bit safety net (uncredited entropy) which at least Debian
shall not remove.

I think Debian also dumps some low-entropy-per-bit crap into /dev/random
during boot (again, not credited), such as the boot kernel logs.  We could
increase the density of that entropy a lot using gzip -0 or something like
that... is an uncredited low-entropy-per-bit dump into the pool detrimental
to its quality?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
