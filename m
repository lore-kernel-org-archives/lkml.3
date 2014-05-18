Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaERKor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 06:44:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46791 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaERKop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 06:44:45 -0400
Date: Sun, 18 May 2014 13:43:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        kernel-janitors@vger.kernel.org, kernelnewbies@kernelnewbies.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] Remove useless return variables
Message-ID: <20140518104314.GK15585@mwanda>
References: <1400379310-10214-1-git-send-email-peter.senna@gmail.com>
 <87y4xzpti4.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4xzpti4.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 10:04:35PM -0700, Andi Kleen wrote:
> Peter Senna Tschudin <peter.senna@gmail.com> writes:
> 
> > This patch remove variables that are initialized with a constant,
> > are never updated, and are only used as parameter of return.
> > Return the constant instead of using a variable.
> 
> This ret variable pattern is pretty standard in Linux, as it makes it
> easier to add new code that may trigger new errors
> (using the usual "goto forest" error handling pattern)
> 
> I don't see any benefit in whole-sale removing it. The compiler
> doesn't care about it and will generate the same code in any
> case.

Peter is not selling this in the right way, it's not about saving
memory.  The patch is good because:

	return IRQ_HANDLED;

is clearer to read than:

	return ret;

And then when you remove the one user, you may as well remove the unused
variable.  You could leave it there for future work but really it's not
hard to add it back if it's needed.

regards,
dan carpenter

