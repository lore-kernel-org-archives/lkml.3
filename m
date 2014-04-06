Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaDFGmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 02:42:11 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48129 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaDFGmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 02:42:09 -0400
Message-ID: <5340F73A.6090600@colorfullife.com>
Date: Sun, 06 Apr 2014 08:42:02 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Davidlohr Bueso <davidlohr@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Greg Thelen <gthelen@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] ipc,shm: disable shmmax and shmall by default
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com> <1396386062.25314.24.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com> <20140401142947.927642a408d84df27d581e36@linux-foundation.org> <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com> <20140401144801.603c288674ab8f417b42a043@linux-foundation.org> <CAHGf_=r5AUu6yvJgOzwYDghBo6iT2q+nNumpvqwer+igcfChrA@mail.gmail.com> <1396394931.25314.34.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rH+vfFzRrh35TETxjFU2HM0xnDQFweQ+Bfw20Pm2nL3g@mail.gmail.com> <1396484447.2953.1.camel@buesod1.americas.hpqcorp.net> <533DB03D.7010308@colorfullife.com> <1396554637.2550.11.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rT7WswD0LOxVeDDpae-Ahaz4wEcpE8HLmDwOBw598z8g@mail.gmail.com> <1396587632.2499.5.camel@buesod1.americas.hpqcorp.net> <CAHGf_=pvN96SgLYdR3jPn8VaEfAjq-LX=r=PQRvPGqi6xFJoxQ@mail.gmail.com>
In-Reply-To: <CAHGf_=pvN96SgLYdR3jPn8VaEfAjq-LX=r=PQRvPGqi6xFJoxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/05/2014 08:24 PM, KOSAKI Motohiro wrote:
> On Fri, Apr 4, 2014 at 1:00 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> I don't think it makes much sense to set unlimited for both 0 and
>> ULONG_MAX, that would probably just create even more confusion.
I agree.
Unlimited was INT_MAX since 0.99.10 and ULONG_MAX since 2.3.39 (with 
proper backward compatibility for user space).

Adding a second value for unlimited just creates confusion.
>> But then again, we shouldn't even care about breaking things with shmmax
>> or shmall with 0 value, it just makes no sense from a user PoV. shmmax
>> cannot be 0 unless there's an overflow, which voids any valid cases, and
>> thus shmall cannot be 0 either as it would go against any values set for
>> shmmax. I think it's safe to ignore this.
> Agreed.
> IMHO, until you find out any incompatibility issue of this, we don't
> need the switch
> because we can't make good workaround for that. I'd suggest to merge your patch
> and see what happen.
I disagree:
- "shmctl(,IPC_INFO,&buf); if (my_memory_size > buf.shmmax) 
perror("change shmmax");" worked correctly since 0.99.10. I don't think 
that merging the patch and seeing what happens is the right approach.
- setting shmmax by default to ULONG_MAX is the perfect workaround.

What reasons are there against the one-line patch?
 >
 > -#define SHMMAX 0x2000000                /* max shared seg size 
(bytes) */
 > +#define SHMMAX ULONG_MAX                /* max shared seg size 
(bytes) */
 >

--
     Manfred
