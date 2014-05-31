Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaEaRyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 13:54:41 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:52518 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaEaRyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 13:54:39 -0400
Message-ID: <538A175C.80705@colorfullife.com>
Date: Sat, 31 May 2014 19:54:36 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linux API <linux-api@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: MSGMNB and MSGMAX: good default values?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

until now, every sysadmin/distro had to update the sysv limits.
For shm, the new proposal is to increase the limits to (nearly) ULONG_MAX.

Right now, I try to create patches that also increase the limits for 
sysv msg, but I got stuck:

- MSGMNI is trivial, just increase it to nearly IPCMNI.

- MSGMNB is not an upper limit, it is actually the default amount of 
data that can be stored in a message queue before senders must sleep.
   Since Linux-0.99.10, it always was 16384.

   A websearch shows that for both db2 and oracle, the recommendation is 
65536.

   It seems that redhat has increased the value to 65536:
https://bugzilla.redhat.com/show_bug.cgi?id=862597

Tuxedo seems to use sysv messages and the documentation warns that too 
large values are harmfull:
http://read.pudn.com/downloads142/doc/618733/tux-a11-80/manual/13-ADM-PERF-Notes.pdf

- MSGMAX: Same issue as above: it was slightly below 4096 and since 2.6 
it is 8192.

Any proposals?
Right now, I would leave MSGMAX and MSGMNB as they are.

--
     Manfred
