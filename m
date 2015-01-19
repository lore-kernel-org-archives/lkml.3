Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbbASR6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:58:41 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45253 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbASR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:58:39 -0500
Date: Mon, 19 Jan 2015 09:58:35 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] MTD: Deletion of checks before the function call
 "iounmap"
Message-ID: <20150119175835.GH9759@ld-irv-0074>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54BBE87C.9020705@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BBE87C.9020705@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 06:08:12PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 18 Jan 2015 17:30:23 +0100
> 
> The iounmap() function performs also input parameter validation.
> Thus the test around the call is not needed.

Is this guaranteed for all arch'es? I expect that it would be, but I see
that, for instance, ARM allows replaceable iounmap() for
subarchitectures. Also, I see checks for various sorts of static
mappings in ARM and x86; these likely (always?) cover the NULL case, but
they're not always straightforward.

Anyway, I'm essentially saying that I'd like to be 100% sure we have a
guarantee before dropping all these.

> This issue was detected by using the Coccinelle software.

What script? Hand-rolled I guess?

Brian
