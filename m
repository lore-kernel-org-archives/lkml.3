Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaCJOiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:38:52 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64030 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaCJOiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:38:51 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <alpine.LNX.2.00.1403101525220.3690@pobox.suse.cz>
References: <alpine.LNX.2.00.1402271153480.21399@pobox.suse.cz>
	<alpine.LNX.2.00.1403031519500.7030@pobox.suse.cz>
	<alpine.LNX.2.00.1403101525220.3690@pobox.suse.cz>
Date: Mon, 10 Mar 2014 15:38:50 +0100
Message-ID: <CAKMK7uG1PG=h8uiofNXt_-GOGgL354skaQeqA5OxK4VbYk2Vkg@mail.gmail.com>
Subject: Re: i915 resume-from-hibernation problems on resume with current
 Linus' tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 3:25 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 3 Mar 2014, Jiri Kosina wrote:
>> > first things first: this is hard to bisect, because it doesn't happen
>> > reliably and I don't really know what is the first good version, as I had
>> > a delay in following Linus' tree.
>> >
>> > What happens is that after resumption from S4 (disk), Xorg session is in
>> > complete havoc -- the windows don't redraw properly, sometimes the mouse
>> > pointer is "jailed" on a small rectangle in the middle of the screen, etc.
>> >
>> > I have captured 'drm.debug=14' output of the failing resume ... I guess
>> > this is realted to the
>> >
>> > *ERROR* render ring initialization failed ctl 0001f001 head 00003004 tail 00000000 start 00003000
>> >
>> > as it doesn't seem to be there in case of resumption that works properly.
>> >
>> > Please see the dmesg from the broken case below.
>>
>> I encountered this again with -rc5.
>>
>> If there is anything I can do to help debug this, please let me know.
>
> I hate to be doing this, but ... ping? :)

gm45 and rendering ring init failures. We've seen this occasionally
crop up due to rather unrelated changes. Some even hit stable
backports and had to be backed out again. We essentially have no clue
what's amiss, but it seems to /mostly/ work. Thus far I've only hear
reports of this for gm45 and not yet really for upstream. Until
someone digs up more evidence I think we need to classify this as a
rare heisenbug and not really a regression :(

One thing we could try is to simply repeat the ring init setup, maybe
after a gpu reset or something like that.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
