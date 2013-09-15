Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3IONrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 09:47:32 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:43227 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab3IONrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 09:47:31 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20130912141625.GA23357@somewhere>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	<20130911220228.GB15367@somewhere>
	<000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
	<20130912141625.GA23357@somewhere>
Date: Sun, 15 Sep 2013 16:47:29 +0300
Message-ID: <CAOtvUMfndvkCEauQw11ZBoBM_6sf-wGi-QruHu1FApwuL8h47w@mail.gmail.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of cpus.
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 5:16 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Sep 12, 2013 at 02:10:56PM +0000, Christoph Lameter wrote:
>> On Thu, 12 Sep 2013, Frederic Weisbecker wrote:
>>
>> > Why not do this from userspace instead?
>>
>> Because the cpumasks are hardcoded in the kernel code.
>>
>
> Ok but you can change the affinity of a kthread from userspace, as
> long as you define a cpu set that is among that kthread's cpus allowed.


There is also the problem of kernel threads registering timers. We
don't have a good way to migrate those yet, I believe.

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
