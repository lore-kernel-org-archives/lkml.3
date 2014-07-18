Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935300AbaGRVZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:25:26 -0400
Received: from imap.thunk.org ([74.207.234.97]:44316 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbaGRVZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:25:25 -0400
Date: Fri, 18 Jul 2014 17:25:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Price <price@mit.edu>
Subject: Re: [PATCH] random: check for increase of entropy_count because of
 signed conversion
Message-ID: <20140718212504.GC18775@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Greg Price <price@MIT.EDU>
References: <20140716083308.GF1491@thunk.org>
 <442eeebeb78f9f2d4066ad923f4144fc2110c6f7.1405538086.git.hannes@stressinduktion.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <442eeebeb78f9f2d4066ad923f4144fc2110c6f7.1405538086.git.hannes@stressinduktion.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 09:18:15PM +0200, Hannes Frederic Sowa wrote:
> The expression entropy_count -= ibytes << (ENTROPY_SHIFT + 3) could
> actually increase entropy_count if during assignment of the unsigned
> expression on the RHS (mind the -=) we reduce the value modulo
> 2^width(int) and assign it to entropy_count. Trinity found this.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Greg Price <price@mit.edu>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> ---
> As indicated by credit_entropy_bits entropy_count cannot get negative,
> so I don't see any reason to include a check for entropy_count < 0
> here. Do you agree?

No, the check is important; after we subtract ibytes << (ENTROPY_SHIFT
+ 3) we could drive entropy_count negative, and we don't want to
trigger the WARN_ON().

I'll modify the patch to keep the check.

						- Ted

