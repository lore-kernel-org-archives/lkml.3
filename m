Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab3BGEjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:39:48 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:46910 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3BGEjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:39:46 -0500
Date: Wed, 06 Feb 2013 22:39:39 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2] lib: vsprintf: Add %pa format specifier for
 phys_addr_t types
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>, mingo@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
In-Reply-To: <1358900093-16412-1-git-send-email-stepanm@codeaurora.org>
	(from stepanm@codeaurora.org on Tue Jan 22 18:14:53 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1360211979.12062.20@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 06:14:53 PM, Stepan Moskovchenko wrote:
> Add the %pa format specifier for printing a phys_addr_t
> type and its derivative types (such as resource_size_t),
> since the physical address size on some platforms can vary
> based on build options, regardless of the native integer
> type.
> 
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>

Ok, I know I'm late to the party, but doesn't LP64 apply here? Are we  
really capable of building on a target where "long" and "pointer" are  
different sizes? Last I checked the kernel was full of that assumption  
because there was an actual standard and we demanded that the compiler  
building us comply with it, just like MacOS X and the BSDs do:

Standard:
http://www.unix.org/whitepapers/64bit.html

Rationale:
http://www.unix.org/version2/whatsnew/lp64_wp.html

Insane legacy reasons Windows decided to be "special":
http://blogs.msdn.com/oldnewthing/archive/2005/01/31/363790.aspx

Thus "unsigned long" should by definition be big enough. Using unsigned  
long long means you're doing 64 bit math on 32 bit targets for no  
apparent reason.

What did I miss?

Rob