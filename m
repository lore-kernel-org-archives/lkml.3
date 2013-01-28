Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3A1LJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:09:07 -0500
Received: from multi.imgtec.com ([194.200.65.239]:1646 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab3A1LJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:09:03 -0500
Message-ID: <51065C2F.9010505@imgtec.com>
Date: Mon, 28 Jan 2013 11:08:31 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <5102BB38.3050207@imgtec.com> <201301260025.10020.arnd@arndb.de> <51062460.9060902@synopsys.com>
In-Reply-To: <51062460.9060902@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_28_11_08_33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet

On 28/01/13 07:10, Vineet Gupta wrote:
>> You don't need Acked-by statements on every single patch, but having
>> more of those is certainly benefitial. When it comes to the merge
>> window, please send a pull request to Linus, and keep me on Cc,
>> so I can weigh in with an additional Ack to the series.
> 
> While the first pull request can go directly from github, I presume the logistics
> for setting up accounts on kernel.org will only kick start after the first batch
> of code has been accepted. I can't seem to find any discussions on lists to that
> effect.

this may be relevant:

https://korg.wiki.kernel.org/index.php/Userdoc:getting_account

> BTW I went back to hexagon submission patches in 2011 and it seems every new arch
> makes the exact same mistakes:
> -idle sleep race
> -faltering in TIF_WORK_RESUME and in fixing that breaking the syscall restarting
> -redundant symbols in module.c
> ...
> 
> Will it make sense to have a checklist-for-new-arches with concrete examples of
> broken and fixed code so that you, Al and other reviewers don't have to repeat the
> same thing over and over again.

I suspect some of the problem is that the code will have been copied
from other architectures which were subsequently fixed, but the fixes
weren't being tracked while the out of tree port was being updated.

I don't think it's a bad idea to have a checklist like that, but I think
this is always going to continue to happen, and be dependent on when the
arch port was first written, so such a checklist may well need updating
lots based on what mistakes are most commonly made.

I'd suggest the following generic things:
* Work with upstream in the first place to minimise the period the arch
is out of tree (tends not to happen as much as we'd all like).
* Read linux-arch ML so that common per-arch problems are noticed as
soon as they're apparent, and cc it when those sorts of issues are raised.
* Look at comments for other/previous arch submissions (I definitely
made a fair few fixes/changes after looking at c6x, tile, and arc comments).
* Documenting these arch specific issues (like Al's signal brain dump
which was very valuable to understand the subtleties).

Cheers
James

