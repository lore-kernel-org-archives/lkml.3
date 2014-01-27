Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaA0JNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:13:49 -0500
Received: from dehamd003.servertools24.de ([31.47.254.18]:36706 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbaA0JNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:13:47 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jan 2014 04:13:47 EST
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <52E6219A.3020405@ladisch.de>
Date: Mon, 27 Jan 2014 10:06:34 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Network Nut <sillystack@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: WaitForMultipleObjects/etc. In Kernel
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de> <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com>
In-Reply-To: <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Network Nut wrote:
> As you know, under Windows, synchronization objects such as {event | mutex |
> semaphore | timer}; all have names that are computer-global. Process B can
> open, and use, any {event | mutex | semaphore | timer} that was created by
> process A, as long as Process B knows the name that was used by Process A to
> create the {event | mutex | semaphore | timer}. [...]
> Is there a method I can use where Process A and Process B can both refer to
> the same eventfd by name?

In Unix, the most common method of sharing file descriptors is by
letting child processes inherit them.  (This also works in Windows, but
is not as efficient due to the process creation overhead.)

Unrelated processes cannot directly open objects created by another
process (with the exception of sockets and pipes, which can be created
in the file system).  However, sharing of any file descriptor is
possible by sending it in a control message through a Unix domain
socket.

> BTW, the man page for epoll_wait seems to be incorrect.

<https://www.kernel.org/doc/man-pages/reporting_bugs.html>

> "The timeout argument specifies the minimum number of milliseconds
>        that epoll_wait() will block."
>
> I think the word "minimum" should be "maximum".

This sentence was copied from the poll(2) man page, where the previous
sentence says "poll() blocks until one of the events occurs".  So the
word "block" implies that no event has occured.


Regards,
Clemens
