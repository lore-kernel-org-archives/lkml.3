Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaL2RJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:09:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46851 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaL2RJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:09:31 -0500
Date: Mon, 29 Dec 2014 18:09:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andy Lutomirski <luto@amacapital.net>,
        kernel list <linux-kernel@vger.kernel.org>, yoongukim@cmu.edu,
        donghyu1@cmu.edu, omutlu@gmail.com
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20141229170927.GA26246@amd>
References: <20141224163823.GA17035@amd>
 <CALCETrW8nrKSZ800C+WaHMK4DCuWnD9TG3dYo7cZwm5j4CpNJQ@mail.gmail.com>
 <20141224172506.GA23683@amd>
 <CALCETrVP2PtB82x4JFFsXDomNKgRTk_3LoMyyk5KCXN=f8_DJw@mail.gmail.com>
 <20141224175040.GA28791@amd>
 <alpine.LRH.2.00.1412291310000.12303@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1412291310000.12303@twin.jikos.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-12-29 13:13:17, Jiri Kosina wrote:
> On Wed, 24 Dec 2014, Pavel Machek wrote:
> 
> > Well... We could periodically scrub (every few miliseconds) pages
> > mapped to userspace. 
> 
> I.e. implement ECC in software. Would be extremely slow though.

No, not really. If you read the cells that are about to go bad, you'll
update them. Agreed on extremely slow.

> > We might be able to do some magic and disallow cache flushes to 
> > userspace programs. 
> 
> My understanding is that cflush is not strictly necessary, it only makes 
> the issue more likely to trigger.

Umm. Not really, AFAICT.

So, the memory can take "certain ammount" of "neighboring
accesses". You need to do that ammount before next refresh.

> If you modify the pattern so that it neraly fits into cacheline (but not 
> really), you would be able to produce similar (if not the same) cache 
> eviction pattern as if without explicit cflush. Right?

No, I don't think so.

Well.. you need to generate certain ammount of traffic on the address
lines, and it corrupts "neighboring" cells. I wish I knew more about
DRAM... If you'll read a cache line, you can't "break" it as reads
refreshes it. You need to do few miliseconds worth of reads, AFAICT.

If you'll just keep reading cachelines, the cachelines you read will
not be "neighboring" enough to the "target" cells you want to break.
									
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
