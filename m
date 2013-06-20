Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331Ab3FTO0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:26:33 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:60960 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935359Ab3FTO0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:26:32 -0400
Date: Thu, 20 Jun 2013 16:26:25 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, David Daney <david.daney@cavium.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix OCTEON BUG() warnings a different way.
Message-ID: <20130620142625.GA30061@linux-mips.org>
References: <1371679468-29479-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371679468-29479-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 03:04:28PM -0700, David Daney wrote:

> Signed-off-by: David Daney <david.daney@cavium.com>

I replaced my fix with your fix but left he direct inclusion of
<linux/bug.h>.

Let as homework for a later point: make BUG() invoke unreachable() if
CONFIG_BUG is diabled, something like that.  This will improve code
generation for GCC 4.5+ but for older compilers unreachable() is
defined as do { } while (1) so will emit extra code.

Thanks,

  Ralf
