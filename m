Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3EFPGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:06:12 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45243 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab3EFPGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:06:11 -0400
Message-ID: <5187C6B6.7070605@ahsoftware.de>
Date: Mon, 06 May 2013 17:05:26 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130421 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rtc-linux@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: adjusting the monotonic system time (from inside the kernel)
References: <5187B813.8000907@ahsoftware.de>
In-Reply-To: <5187B813.8000907@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.05.2013 16:02, schrieb Alexander Holler:

> 
> But I would prefer the following:
> 
> hw-clock --> kernel -> system-time
> 
> Problem is that the hw-clock in question doesn't offer something like a
> tick. It just might send a timestamp with millisecond precision whenever
> it wants.
> 
> Because I don't want to reinvent the wheel and because I think there are
> some people which already have spend some thoughts on similiar things,
> I'm asking here before I try to implement something which then never
> might find it's way into the mainline kernel.
> 
> Any hints, suggestions, whatever?

To offer something for discussion I'm thinking about:

When a timestamp with millisecond precision is received, instruct the
kernel to adjust the system time in the next minute for the calculated
offset.

Question here would be what to choose as window to adjust the time (the
"next minute" above"). I think that should depend on the offset. But
what are acceptable values? One minute to adjust the clock for offsets
up to +-500ms? Two minutes if the offset is one second? ...

As I never spend a thought about such before, I just don't have any
pointers what would be acceptable.

Regards,

Alexander
