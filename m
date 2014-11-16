Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaKPSBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 13:01:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50023 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbaKPSBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 13:01:02 -0500
Date: Sun, 16 Nov 2014 18:01:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel:signal.c Fix coding style errors and warnings.
Message-ID: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <1415980615-12345-1-git-send-email-ionut.m.alexa@gmail.com>
 <20141116024752.GP7996@ZenIV.linux.org.uk>
 <CAKF-a2AYAPy2ENaFVanFCWZ_sXHPy_K_uH6zo5apT-kLLaqONA@mail.gmail.com>
 <20141116170810.GQ7996@ZenIV.linux.org.uk>
 <CAKF-a2AhmE4iZHsRNgyp6Le6uaDNSUjbxQENm5sTYD3f24ORnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKF-a2AhmE4iZHsRNgyp6Le6uaDNSUjbxQENm5sTYD3f24ORnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 07:28:29PM +0200, Ionut Alexa wrote:
> I worked a while in critical automotive software application. There is
> nothing more important than to know your program is running start-to-end in
> the correct order. For the automotive indurstri is safety critical. For PC
> application is not madatory. But for Operating systems, it is a good
> practice. If the function exits from a diferent point depending on some
> conditions, it is hard to debug when the kernel behavior is not the
> expected one.

Excuse me, but this is pure cargo-cult argument.  There is a lot more to
complexity of debugging than blind application of rules like that.  Sure,
the control flow graph affects it.  However, proposed change ("replace
all returns with goto to the end") is not an improvement at all.

There are reasons behind these practices; applying them without understanding
those is not going to work.  And the reasons behind the "single exit point
is better" apply to those goto just as well as they did to those return;
control flow remains the same, after all.
