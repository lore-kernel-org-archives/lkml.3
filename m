Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab3LJLBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:01:12 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34414 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751805Ab3LJLBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:01:09 -0500
Message-ID: <52A6F469.9020109@hurleysoftware.com>
Date: Tue, 10 Dec 2013 06:00:57 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Karl Dahlke <eklhad@comcast.net>, mpatocka@redhat.com
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12] Broken terminal due to echo bufferring
References: <alpine.LRH.2.02.1312082127020.19329@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1312092103290.11182@file01.intranet.prod.int.rdu2.redhat.com> <20131110054819.eklhad@comcast.net>
In-Reply-To: <20131110054819.eklhad@comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 05:48 AM, Karl Dahlke wrote:
> | An involved discussion about race conditions and asynchronous events,
> | which is beyond me.
> | Please continue; I'm sure you will figure it out,
> | and perhaps educate me along the way.
> | But this thread began with the following program that revealed,
> | I believe, the same echo crlf bug that I pointed out.
>
>> #include <stdio.h>
>> #include <unistd.h>
>>
>> int main(void)
>> {
>> int c;
>> while ((c = getchar()) != EOF) {
>> if (c == '\n') write(1, "prompt>", 7);
>> }
>> return 0;
>> }
>
> Peter sent me a patch which fixed my bug, in its console switch form.
> And also seemed to fix the bug whenever I was in a cooked mode program.
> So I was happy.
> For grins I compiled this program, to see if it also
> ran properly.
> It does, while it is running.
> Prompt and newline come out in sequence, in order,
> and everything looks right.
> Hit control d, for EOF, as the program expects, and all is well.
> But hit ^c for interrupt, and as Tilly says,
> "All hell done broke loose now."
> The tty spills out a bunch of accumulated text that it has displayed in the past.
> Don't know where it comes from, or why.
> I ran the program several times, interrupt,
> and the same thing happened each time, even the same stored output,
> as though it were a 4k block that was retained from somewhere.
> Try it and see (with Peter's latest patches).

Hi Karl,

That's happening because you're also running the 'tty: Fix ^C echo' patch
series which pre-dates this fix and is _not_ compatible with it.

I've already asked Greg to drop that series for other reasons (which he
had planned on anyway).

Regards,
Peter Hurley

