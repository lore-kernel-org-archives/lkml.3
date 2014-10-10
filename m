Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaJJQgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 12:36:25 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60077 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751356AbaJJQgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 12:36:23 -0400
Date: Fri, 10 Oct 2014 17:36:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] arm: Blacklist gcc 4.8.[012] and 4.9.0 with
	CONFIG_FRAME_POINTER
Message-ID: <20141010163613.GO5182@n2100.arm.linux.org.uk>
References: <1412958374-16090-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412958374-16090-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 12:26:14PM -0400, Peter Hurley wrote:
> gcc versions 4.8.[012] and 4.9.0 generates code that prematurely
> adjusts the stack pointer such that still-to-be-referenced locals
> are below the stack pointer, which allows them to be overwritten
> by interrupts.

I would much rather do this in asm-offsets.c, along side the other ARM
specific buggy compiler test(s).  I'm presently putting together such
a patch.

The information in the thread on linux-omap says only GCC 4.8.1 and
GCC 4.8.2.  Where do you get the other versions from?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
