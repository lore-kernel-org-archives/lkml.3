Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbbA0Wnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:43:43 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:58374 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbbA0Wnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:43:42 -0500
Date: Tue, 27 Jan 2015 22:43:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Rosin <peda@axentia.se>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "sylvain.rochet@finsecur.com" <sylvain.rochet@finsecur.com>,
        "linux@maxim.org.za" <linux@maxim.org.za>
Subject: Re: [PATCH v3 03/13] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories.
Message-ID: <20150127224325.GR26493@n2100.arm.linux.org.uk>
References: <1422337810-3257-1-git-send-email-wenyou.yang@atmel.com>
 <1422338006-3371-1-git-send-email-wenyou.yang@atmel.com>
 <54C7675D.8000204@cogentembedded.com>
 <6740d1ada0cb4c8bbf765728c7443918@EMAIL.axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6740d1ada0cb4c8bbf765728c7443918@EMAIL.axentia.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 09:55:52PM +0000, Peter Rosin wrote:
> I have now checked the assembler output, and apparently it mends the
> input, just as I thought. That might be a fluke, of course, or it might be a
> deliberate shorthand when the destination register is the same as the
> following operand?

I believe it is because we have the assembler in unified asm mode, where
such things are legal (due to Thumb2.)  That means these two are
legal:

	orr	r2, #const
	orr	r2, r2, #const

and equivalent in this context.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
