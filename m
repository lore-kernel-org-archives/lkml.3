Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaKQTJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:09:00 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41190 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaKQTI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:08:57 -0500
Message-ID: <546A47C6.4030309@colorfullife.com>
Date: Mon, 17 Nov 2014 20:08:54 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>,
        Davidlohr Bueso <dave@stgolabs.net>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Doug Ledford <dledford@redhat.com>, linux-newbie@vger.kernel.org
Subject: Re: [PATCH 1/1] ipc/mqueue.c: Drag unneeded code out of locks
References: <fae396b9bc15.545c5b55@langara.bc.ca> <1415780201.24725.2.camel@linux-t7sj.site> <fbb3e8aa49d6.5466da38@langara.bc.ca> <1416086539.12597.15.camel@linux-t7sj.site> <fb59f9ad237f.5468fdbe@langara.bc.ca>
In-Reply-To: <fb59f9ad237f.5468fdbe@langara.bc.ca>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 11/16/2014 08:40 PM, Steven Stewart-Gallus wrote:
> Finally, please don't ignore the rest of my message. Even if my patch
> isn't that good there are lots of ways to compromise and improve it
> such as adding tests, annotations and making it clearer.

I think you were already given ideas how to improve the patch:

a) split the patch.

b) create test cases so that you are able to check that the code still 
behaves as it did before
Did you test the change to mqueue_create()?

c) Give each a good summary of what you want to achieve:
- readability
- coding style
- performance
- avoid a lock entirely, switch to RCU instead of spin_lock(), ...
- reduce the time a lock is held (usually only useful if the reduction 
is significant - both relative and absolute).
- ...

Writing that down also helps you:
There were multiple patches that I've dropped myself - simply because I 
have noticed that the patch doesn't achieve anything useful.

 From your changes: The one to mqueue_read_file might make sense, it 
avoids to hold the spinlock over the snprintf.
For the other changes, I don't see that they improve something, but 
perhaps I have overlooked something.

Best regards,
     Manfred


