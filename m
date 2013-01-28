Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3A1VOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:14:45 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53305 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3A1VOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:14:42 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Mugunthan V N <mugunthanvnm@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Matt Porter <mporter@ti.com>, Chase Maupin <chase.maupin@ti.com>,
        Jason Kridner <jdk@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpsw: Fix interrupt storm among other things
References: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
Date: Mon, 28 Jan 2013 22:14:36 +0100
In-Reply-To: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
	(Pantelis Antoniou's message of "Mon, 28 Jan 2013 15:11:08 +0200")
Message-ID: <87wquxdn7n.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Pantelis" == Pantelis Antoniou <panto@antoniou-consulting.com> writes:

'among other things' is not a very descriptive commit message.

 Pantelis> Fix interrupt storm on bone A4 cause by non-by-the-book
 Pantelis> interrupt handling.  While at it, added a non-NAPI mode
 Pantelis> (which is easier to debug), plus some general fixes.

'bone A4' is also not very descriptive. There also was an A4 revision of
the "old" beaglebone. I guess you're instead referring to a new die
revision?

What is the impact of this change on earlier devices?

 Pantelis> +++ b/Documentation/devicetree/bindings/net/cpsw.txt
 Pantelis> @@ -20,6 +20,7 @@ Required properties:
 Pantelis>  - cpts_clock_shift	: Denominator to convert input clock ticks into nanoseconds
 Pantelis>  - phy_id		: Specifies slave phy id
 Pantelis>  - mac-address		: Specifies slave MAC address
 Pantelis> +- disable-napi		: Disables driver NAPI

napi is not a hardware feature, so it doesn't belong here (if anything,
it should be linux,disable-napi).

-- 
Bye, Peter Korsgaard
