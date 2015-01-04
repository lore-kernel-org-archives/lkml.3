Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbbADUZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:25:07 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:37544 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbbADUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:25:06 -0500
Date: Sun, 4 Jan 2015 15:25:02 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
cc: marc.zyngier@arm.com, rmk+kernel@arm.linux.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <20150104201026.GA23427@amd>
Message-ID: <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
References: <20150104190123.GA20153@amd> <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr> <20150104201026.GA23427@amd>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2015, Pavel Machek wrote:

> On Sun 2015-01-04 15:03:02, Nicolas Pitre wrote:
> > If that is still unacceptable to you for whatever reason, then the least 
> > wrong compromize should be:
> > 
> > 	seq_printf(m, "BogoMIPS\t: 1.00\n");
> > 
> > That'D allow for those broken applications to run while making clear 
> > that the provided value is phony. I was about to suggest 0.00 but that 
> > could trigger a divide by zero error somewhere I suppose.
> 
> I don't know what 1.00 will cause, and neither do you, so what about
> simply reverting the bad patch?

Because the patch wasn't "bad".  It did solve a recurring support 
problem where people did actually complain on the list because the value 
was not what they would have liked.  Removing this meaningless value did 
actually fix that support issue as no more complaints came through for 
the last 1.3 year, and is actually the only way for user space to be 
fixed too.


Nicolas
