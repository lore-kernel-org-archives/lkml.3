Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3H2GBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:01:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57475 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753870Ab3H2GBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:01:18 -0400
Message-ID: <1377756078.1928.89.camel@joe-AO722>
Subject: Re: [PATCH] ARC: Fix __udelay parentheses
From: Joe Perches <joe@perches.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joern Rennecke <joern.rennecke@embecosm.com>
Date: Wed, 28 Aug 2013 23:01:18 -0700
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075140F26@IN01WEMBXA.internal.synopsys.com>
References: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
	 <C2D7FE5348E1B147BCA15975FBA23075140F26@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 05:55 +0000, Vineet Gupta wrote:

> The intent of writing orig code was to generate only 1 MPYHU insn (32*32 =
> high-part-64) for the whole math, at any optimization level whatsoever. If the
> first MPY is overflowing, u r likely spinning for > 10,000 usec (10ms) which is 1
> scheduling tick on ARC - not good - presumably for hardware debug. It would be
> better to use a tight loop there and throw it out later.

It's a delay loop.  Does it matter whether
or not a multiply or division is used?


