Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab3FMCLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:11:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:34351 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3FMCLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:11:22 -0400
X-Spam-Score: -100.8
Message-ID: <51B92A19.9090700@asianux.com>
Date: Thu, 13 Jun 2013 10:10:33 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/softirq.c: delete 'while' looping to improve a
 little performance and beautify code
References: <51B4755B.4020205@asianux.com> <alpine.LFD.2.02.1306101613200.22970@ionos>
In-Reply-To: <alpine.LFD.2.02.1306101613200.22970@ionos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 10:15 PM, Thomas Gleixner wrote:
> On Sun, 9 Jun 2013, Chen Gang wrote:
>> > After finish the internal 'while', need not test TASKLET_STATE_SCHED
>> > again, so looping back to outside 'while' is only for set_bit().
>> > 
>> > When use 'if' and set_bit() instead of 'while', it will save at least
>> > one running conditional instruction, and also will be clearer for readers
>> > (although the binary size will be a little bigger).
> And by doing that you break the atomicity of test_and_set_bit. There
> is a good reason why this is an atomic operation and why the code is
> written as is.
>  

OK, thanks. it is my fault (and also sorry for replying late).

>> > The related patch is "1da177e Linux-2.6.12-rc2"
> How is that patch related to the problem?

Because the modification since Linux-2.6.12-rc2.


Thanks.
-- 
Chen Gang

Asianux Corporation
