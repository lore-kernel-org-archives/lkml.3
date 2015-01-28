Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbbA2CDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:03:37 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:60055 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbbA2CDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:03:34 -0500
Message-ID: <54C8F1C1.7050908@gmail.com>
Date: Wed, 28 Jan 2015 09:27:13 -0500
From: John Moser <john.r.moser@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
CC: linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: OOM at low page cache?
References: <54C2C89C.8080002@gmail.com> <54C77086.7090505@suse.cz> <20150128062609.GA4706@blaptop>
In-Reply-To: <20150128062609.GA4706@blaptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 01:26 AM, Minchan Kim wrote:
>
> Below could be band-aid until we find a elegant solution?
>
>

I don't know about elegant; but I'd be impressed if anyone figured out
how to just go Windows 95 with it and build a Task Master interface.  It
would be useful to have a kernel interface that allows a service to
attach, delegate an interface program, etc., and then pull it up under
certain conditions (low memory, heavy scheduling due to lots of
fork()ing, etc.) and assign temporary high priority.  Basically,
nearly-pause the system and allow the user to select and kill/term
processes, or bring a process forward (for like 10 seconds, then kick it
back again) so the user can save their work and exit gracefully.  At
hard OOM, you could either OOM or pause everything (you'd need a
zero-allocation path to kill things in a user-end OOM handler).

Yeah, imaginative fantasies.  Totally doable, but probably too complex
to bother.  There's all kinds of semaphore inversion or some such to
worry about; how do you ensure an X11 program is 100% snappy when the
system is being thrashed by fork() bombs and memory pressure?

Actually, I have no idea what I'm talking about.
