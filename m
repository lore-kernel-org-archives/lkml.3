Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab3J1PHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:07:13 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34462 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932349Ab3J1PHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:07:06 -0400
X-Sasl-enc: yjjBCh+0iGR15wrEhyYpu+xCVJfYs9HtHcdQn4tYwfdJ 1382972819
Date: Mon, 28 Oct 2013 13:06:56 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        tigran@aivazian.fsnet.co.uk, x86@kernel.org, andi@firstfloor.org
Subject: Re: [PATCH] x86, microcode, Fix long microcode load time when
 firmware file is missing [v2]
Message-ID: <20131028150656.GA15440@khazad-dum.debian.net>
References: <1382961968-20067-1-git-send-email-prarit@redhat.com>
 <20131028143714.GL4314@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028143714.GL4314@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013, Borislav Petkov wrote:
> So Prarit, please split this patch into changes which *directly* address
> the issue and other cleanups ontop. This will simplify review immensely
> as having one single bulky patch is not easy on the eyes.
> 
> Then, make sure to audit the lowlevel drivers whether they're already
> issuing output on the error path before adding new printks arbitrarily.

Something else I couldn't check just from the description (and I apologise,
but I did not look at your patch closely enough to check how you implemented
the functionality on Intel): in the general case, it is NOT acceptable to
bail out if you cannot find the firmware for the first processor.
Mixed-stepping systems do exist, and you might need to update the microcode
of, e.g, just the third processor.

AMD can get away with a half-done implementation of negative caching (or an
"optimised one" depending on your PoV :) ) because they have per-family
firmware files, so even mixed-stepping systems will require only the same
file.  This is *not* true for Intel, which is really annoying.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
