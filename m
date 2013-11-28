Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab3K1RqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:46:22 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:51110 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab3K1RqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:46:20 -0500
Date: Thu, 28 Nov 2013 10:46:14 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: tty/serial eating \n regression in 3.13-rc1
Message-ID: <20131128174614.GB28055@obsidianresearch.com>
References: <20131127181348.GA22723@obsidianresearch.com>
 <1385652419-4732-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385652419-4732-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 10:26:57AM -0500, Peter Hurley wrote:

> Please test out the attached patch and let me know if that solves
> the login whitespace problem.

Yes, it certainly does:
Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

My bisection search showed this should go into 3.12 stable and 3.13..

> Also, please retest the 'cat enable' problem; I have doubts that this
> patch fixes that problem, though.

Correct, this case is still broken, I had guessed they were the same..

Hmm.. it behaves that way in 3.10 as well.. And the issue happens when
the line exceeds 80 cols, and things visually look sane if my x
terminal is 80 cols. So this is something different and probably
expected behavior.

Thanks!
Jason
