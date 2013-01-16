Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab3APC36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:29:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9537 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab3APC36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:29:58 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=2SWw5zcxuqkA:10 a=5SG0PmZfjMsA:10 a=8nJEP1OIZ-IA:10 a=meVymXHHAAAA:8 a=_H3QqDmwaRoA:10 a=80NHVFwJX0u2rGl5lMAA:9 a=wPNLvfGTeEIA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Tue, 15 Jan 2013 21:29:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex =?iso-8859-1?Q?Villac=EDs?= Lasso <a_villacis@palosanto.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Use of memmap= to forcibly recover memory in 3GB-4GB range - is
 this safe?
Message-ID: <20130116022955.GB3854@home.goodmis.org>
References: <50F606A8.2080804@palosanto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50F606A8.2080804@palosanto.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 08:47:20PM -0500, Alex Villacís Lasso wrote:
> The system boots, apparently normally, and I can see the additional
> "memory" in all system reports. However, I cannot quite shake the
> feeling that this "memory" might be in fact an illusion, and an
> attempt to use it will wrap around to the bottom of the memory and
> corrupt anything there. Or worse.
> 
> Some tests that I have tried:
> 1) I have tried to occupy as much memory as possible, by starting
> two virtual machines, plus one instance of eclipse, a browser, and a
> bittorrent client, while running the graphical desktop. I have seen
> the free memory (as reported by "top") fall to under 200 Mb with no
> apparent instability, so this should prove that the extra memory is
> real, right?

If you ran all that and it didn't crash and burn, I'm thinking you are
pretty safe. I would think that if you had 768 megs mapped to nothing,
mirrored to other memory, or any number of other atrocities, your above
actions would most likely show some horrible failure.

I think you are correct in assuming that if the MTRR mappings shows
memory there, it may just be a bug in the BIOS that is not adding it.

> 2) I have recompiled the kernel to support the memtest parameter.
> When using it, the extra memory segment appears to be as healthy as
> other areas of memory. However this might only mean that it is
> wrapping into healthy low RAM.
> 
> Is my reasoning sane? Is there a way to know, once and for all,
> whether the extra "memory" is real and safe to use or not?

I can think of writing a kernel module that reads and writes to these
locations just to make sure. But other than that, I'm not aware of
anything. Maybe someone else could offer more.

-- Steve

