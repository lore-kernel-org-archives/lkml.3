Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaKCHTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:19:10 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:60361 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaKCHTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:19:08 -0500
Date: Mon, 3 Nov 2014 15:18:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Evan Gilman <evan@pagerduty.com>
Cc: steffen.klassert@secunet.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, mwoodson@redhat.com
Subject: Re: Sporadic ESP payload corruption when using IPSec in NAT-T
 Transport Mode
Message-ID: <20141103071856.GA28745@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALEwOppDfAHV2rghk_nO2Xbjqxd=cbUeW7oWOkAgZtcmjPdHuQ@mail.gmail.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evan Gilman <evan@pagerduty.com> wrote:
>
> I tried to find a reference to the previous report of aesni-intel
> causing IPSec corruption under Xen - I'd be interested to read it if
> anyone here has it on hand. For now, we are looking to blacklist
> aesni-intel as we have no other suitable solution, and when combined
> with our other bug, has a detrimental effect on our infrastructure.

Unfortunately the bug is marked as private but it's

https://bugzilla.redhat.com/show_bug.cgi?id=1085025

FWIW it was also observed on AWS.  There is speculation that
switching to HVM may fix it.  If that were the case, then it's
highly likely that this is a bug in the Xen paravirt code.

It would also mean that if you cannot switch over to HVM then
the most appropriate fix would be to not use aesni-intel.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
