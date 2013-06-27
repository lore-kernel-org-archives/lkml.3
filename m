Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3F0KXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:23:16 -0400
Received: from dub0-omc1-s20.dub0.hotmail.com ([157.55.0.219]:14198 "EHLO
	dub0-omc1-s20.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253Ab3F0KXN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:23:13 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jun 2013 06:23:13 EDT
X-TMN: [bWM1/qm0vqtBmxyYHXDSBbkYDC66/M6f]
X-Originating-Email: [jderehag@hotmail.com]
Message-ID: <DUB111-W837E626278383276EEE01FDD750@phx.gbl>
From: Jesper Derehag <jderehag@hotmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Question: Userspace detection of ptraced process?
Date: Thu, 27 Jun 2013 10:16:59 +0000
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 27 Jun 2013 10:16:59.0947 (UTC) FILETIME=[75E55FB0:01CE731F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Is there a way of getting info about any task that is being ptraced (from userspace)?

I know that in more recent kernels you can get an event through a NETLINK_CONNECTOR socket.
But I was hoping that you could get the same information say through the siginfo argument to waitid or something similar?

I have tried different variations on the code below but it seems like there is no dependable way to get the siginfo while child_pid is beeing trapped.
I get rc=-1 when child is traced (and trapped), and therefore siginfo is undefined.

I suspect it might be due to that when you ptrace child, the tracer becomes the parent and that is why I cannot get any accurate siginfo data within the original parent?
The reason for why I do WNOHANG here is that in my application its very important that I do not block. So I was hoping on just doing a "poll" of the pid status here.

rc = waitid(P_PID, child_pid, &info, WNOHANG);
if((rc == 0 || rc == child_pid) && info.si_pid != 0)
    if(info.si_code == CLD_TRAPPED)
        printf("child_pid=%d is being ptraced!", child_pid);

Anyway, any ideas of why waitid(..) doesnt work? And if waitid(..) approach is not possible, is there any additional clever ways to figure out if  a child is ptraced other than the NETLINK_CONNECTOR way? 
EVENT_PTRACE is unfortunatly not available in the kernel I am using at the moment (kernel 3.0) . 
And no, its not really possible to update or patch the kernel at this point.

Thanks.

Regards,
Jesper Derehag 		 	   		  