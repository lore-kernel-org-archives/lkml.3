Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3GDSIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 14:08:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53102 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728Ab3GDSIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 14:08:50 -0400
Message-ID: <51D5BA25.9060207@zytor.com>
Date: Thu, 04 Jul 2013 11:08:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: scheduling while atomic & hang.
References: <20130704015525.GA8486@redhat.com> <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
In-Reply-To: <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 07:49 PM, Linus Torvalds wrote:
>>  [<ffffffff816f42bf>] __schedule+0x94f/0x9c0
>>  [<ffffffff816f487e>] schedule_user+0x2e/0x70
>>  [<ffffffff816f6de4>] retint_careful+0x12/0x2e

This call trace does indeed indicate that we took a hardware interrupt 
which caused a reschedule.  It doesn't necessarily have to be a quantum 
expiration interrupt, it could just as easily be an I/O completion 
interrupt.

	-hpa

