Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3FLQCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:02:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56694 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753513Ab3FLQCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:02:16 -0400
Message-ID: <1371052935.2069.14.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: forgive use of mixed case variables
 measuring units
From: Joe Perches <joe@perches.com>
To: Phil Carmody <phil.carmody@partner.samsung.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Date: Wed, 12 Jun 2013 09:02:15 -0700
In-Reply-To: <003601ce676c$a92360c0$fb6a2240$%carmody@partner.samsung.com>
References: <1369825370-31901-1-git-send-email-phil.carmody@partner.samsung.com>
	 <1369826652.22004.106.camel@joe-AO722>
	 <003601ce676c$a92360c0$fb6a2240$%carmody@partner.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 15:59 +0300, Phil Carmody wrote:
> I agree that a creeping list of exceptions where CamelCase
> is to be overlooked would be bad, but I would argue that 
> perhaps my exceptions aren't actual CamelCase - they're
> (pretending to be) SI units, and just happen to match the
> CamelCase regexp. I did a grep for my regexp, and everything
> I noticed in a quick scan did look like a justifiable 
> variable name.

Maybe, but this regex misses variants like:

regulator_min_uA_show

Maybe "^[a-z_]*_[numk][VAS](?:_\w+)?$"

But this regex also does not match on other common
sound variants "_dB", "_mB" and temperature like "_mC".

There's also the arm bL variant (bigLittle)

So I guess it'd be better to use
"^[a-z_]*_[a-z][A-Z](?:_\w+)?$"


