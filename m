Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab3EQQlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:41:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:40447 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab3EQQls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:41:48 -0400
Message-ID: <51965DC0.7030901@ahsoftware.de>
Date: Fri, 17 May 2013 18:41:36 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Subject: Re: [PATCH] tty: make sure a BUG is hit if tty_port will be destroyed
 before tty
References: <5195B561.3090503@ahsoftware.de> <1368774728-4817-1-git-send-email-holler@ahsoftware.de> <20130517153136.GC19541@kroah.com>
In-Reply-To: <20130517153136.GC19541@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.05.2013 17:31, schrieb Greg Kroah-Hartman:
> On Fri, May 17, 2013 at 09:12:08AM +0200, Alexander Holler wrote:
>> tty depends on tty_port until tty_release() was called. Make sure a BUG
>> will be hit, if tty_port will be destroyed before tty.
>
> So you want to ensure that we crash a machine?  No, please never add

Exactly. Let me quote myself:

 >> As described before, it ends up with memory corruption because freed
 >> memory is used, so if a BUG() happens, it doesn't help much. E.g. with
 >> kernel 3.9.2 I never have seen a bug, just a rebooting machine
 >> (sometimes minutes after the real bug happened).

> BUG() statements to the kernel, unless something _really_ bad is going
> to happen if we don't call it.  I never want to stop a machine from
> running, do you?

Yes. I'm not sure how you define _really_ bad, but a memory corruption 
with undefined result is exactly how I would define such.

And in the case of rfcomm, the box doesn't stop, at least not here. Just 
the process is killed together with an easy to identfiy oops. And the 
BUG_ON() prevents that memory will become corrupted and the machine is 
still usable afterwards. If that isn't a use case for BUG_ON(), I really 
don't know what else would be a use case for it.

> I can't take this as-is, why not just fix the root problem?

First I'm still not sure about the root problem and awaiting some 
response to my mail before that patch. As noted in the mail with the 
patch, 3.10-rc1 looks different, so the it might already be fixed there, 
even if rfcomm doesn't handle the tty as it (now in 3.8 and 3.9) should 
be (I haven't tested 3.10-rc1 up to now).

Second, if I would fix the bug in rfcomm, as Peter suggested, I still 
would not know if the same problem doesn't appear in any other user of 
ttys too, so even if I would fix rfcomm, I still would want that 
BUG_ON() to make sure I don't get a memory corruption whenever another 
similiar bug is hit.

Regards,

Alexander Holler

