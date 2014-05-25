Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaEYUPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 16:15:39 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:45390 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaEYUPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 16:15:38 -0400
Message-ID: <53824F66.4080003@colorfullife.com>
Date: Sun, 25 May 2014 22:15:34 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: scaling of msgmni
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nadia,

You added a patch that adds dynamic scaling of MSGMNI (f7bf3df8).
The description begins with:
> On large systems we'd like to allow a larger number of message queues.  In
> some cases up to 32K.  However simply setting MSGMNI to a larger value may
> cause problems for smaller systems.
Which problems did you imagine?

For shm, we have just completed patches that set the limit to (nearly) 
ULONG_MAX as default.

Perhaps we could do the same step for msg, too?
Remove the whole logic, increase the limits to the maximum supported.
(or, if your concerns are valid and apply to shm, too - drop the patch 
for shm).

--
     Manfred
