Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaEAQeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:34:14 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:35665 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbaEAQeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:34:13 -0400
Date: Thu, 1 May 2014 10:34:07 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/3] mtd: nand: add randomizer support
Message-ID: <20140501163407.GB3296@obsidianresearch.com>
References: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 03:09:49AM +0200, Boris BREZILLON wrote:
> Hello,
> 
> This series is a proposal to add support for randomizers (either software
> or hardware) to NAND flash controller drivers.

FWIW, I think the term for reversibly combining a PRBS with data is
'scrambling', it is often used in communication systems for similar
reasons - probabilisticly increasing transition density.

randomizing is something else entirely :)

BTW, there are security concerns here. The scrambler PRBS must not be
predictable by the user, otherwise they can write data that undoes the
scramble and defeat it, ie deliberately writing the last 2k of a 4k
write block as all 0's after scrambling could cause the first 2k to be
lost. That feels like something that could be scary ..

Jason
