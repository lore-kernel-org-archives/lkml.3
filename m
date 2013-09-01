Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab3IAUQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 16:16:13 -0400
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:43715 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3IAUQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 16:16:12 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: 3.11-final plan: unpriviledged user can crash the kernel (using bluetooth rfcomm)
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20130901185038.GA11714@amd.pavel.ucw.cz>
Date: Sun, 1 Sep 2013 13:16:07 -0700
Cc: Gustavo Padovan <gustavo@padovan.org>, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B3715CDF-1D85-45C9-9AD1-DBBD0DF24624@holtmann.org>
References: <20130831100127.GA6711@amd.pavel.ucw.cz> <20130831100933.GA7029@amd.pavel.ucw.cz> <20130831101451.GC7029@amd.pavel.ucw.cz> <20130831104238.GA7767@amd.pavel.ucw.cz> <20130901165525.GK7440@joana> <20130901185038.GA11714@amd.pavel.ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>>>>>> . Python sources for client/server are at 
>>>>>> 
>>>>>> http://tui.cvs.sourceforge.net/viewvc/tui/tui/liveview/
>>>>>> 
>>>>>> . My kernels like to warn about
>>>>> System is debian stable with gnome2.
>>>> 
>>>> And no, it is not fixed in 3.11-rc7.
>>> 
>>> 2.6.32-5-686 from debian seems to work.
>> 
>> Could you try linux-next? We recently pushed a rework of the RFCOMM tty
>> handling, it should fix this. The work was too big to be pushed to 3.11
> 
> So... In 3.11 unpriviledged user can crash the kernel, but the fix is
> too big, so we release it without the fix?
> 
> Somehow, I don't think that's good idea.

can you boot a bluetooth-next kernel and see if the planned changes are fixing this or not. I would like to have that confirmed before we start any speculations here.

If the RFCOMM TTY rework that we have in bluetooth-next fixes this issue, then we can have a look at if this can be patched for 3.11 or a stable kernel without having to include the whole patch series. Or if the TTY subsystem changed from 2.6.32 so much that we have to take the whole changes.

However, please also note there is a different between RFCOMM sockets and RFCOMM TTYs. I would be curious if only the TTY part is affected or also the socket part.

Regards

Marcel

