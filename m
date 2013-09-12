Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3ILXGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:06:31 -0400
Received: from longford.logfs.org ([213.229.74.203]:60219 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3ILXG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:06:29 -0400
Date: Thu, 12 Sep 2013 17:31:48 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: John Stultz <john.stultz@linaro.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130912213148.GE3809@logfs.org>
References: <10005394.BRCyBMYWy3@tauon>
 <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com>
 <20130910203853.GG29237@thunk.org>
 <522F851D.1040101@linaro.org>
 <20130910211009.GI29237@thunk.org>
 <522F984C.2070909@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <522F984C.2070909@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 September 2013 15:08:12 -0700, John Stultz wrote:
> Though
> I probably should be hesitant with my suggestions, as I'm not well
> versed in RNG theory.

The basic principle of Ted's RNG is very simple and quite sane:
- You collect as much data as possible, some of which is (hopefully)
  unpredictable.
- All the data gets dumped into a small buffer.
- When reading from the buffer, you create a crypto-hash of the entire
  buffer.  Even if most of the buffer is predictable, the few
  unpredictable bits will randomly flip every output bit.
- Half of the hash gets returned to the reader, the other half gets
  added back into the pool.

It doesn't matter if you collect predictable data - it neither helps
nor hurts.  But you should collect as much unpredictable data as
possible and do it as cheaply as possible.  If you want to improve the
RNG, you either collect more data, collect better (less predictable)
data or make the collection cheaper.

Jörn

--
People really ought to be forced to read their code aloud over the phone.
That would rapidly improve the choice of identifiers.
-- Al Viro
