Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbbA2PAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:00:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:55636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbbA2PAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:00:48 -0500
Date: Thu, 29 Jan 2015 15:00:47 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next - crashes in rhashtable_shrink
Message-ID: <20150129150047.GB12634@casper.infradead.org>
References: <5398.1422543462@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5398.1422543462@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/15 at 09:57am, Valdis Kletnieks wrote:
> For the past few kernels, I've seen occasional crashes in rhashtable_shrink.
> Looks like the last thing to touch that code was the patch series:
> 
> Subject	[PATCH 0/9 net-next v2] rhashtable: Per bucket locks & deferred table resizing
> Date	Fri, 2 Jan 2015 23:00:13 +0100

Thanks for the report! Based on a similar report I've already tracked
this down to race condition. I'm in the final stages of submitting a
series of fixes for it.
