Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3FFVQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:16:09 -0400
Received: from mail.candelatech.com ([208.74.158.172]:47160 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3FFVQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:16:07 -0400
Message-ID: <51B0FBFC.8040809@candelatech.com>
Date: Thu, 06 Jun 2013 14:15:40 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: stop_machine lockup issue in 3.9.y.
References: <51AF6E54.3050108@candelatech.com> <20130605184807.GD10693@mtj.dyndns.org> <51AF8D4B.4090407@candelatech.com> <51AF91F5.6090801@candelatech.com> <51AFA677.9010605@candelatech.com> <20130605211157.GK10693@mtj.dyndns.org> <1370482492.24311.308.camel@edumazet-glaptop> <20130606031444.GA12335@mtj.dyndns.org> <1370489181.24311.318.camel@edumazet-glaptop> <51B004CD.6080007@candelatech.com> <20130606205514.GC5045@htj.dyndns.org>
In-Reply-To: <20130606205514.GC5045@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 01:55 PM, Tejun Heo wrote:
> Hello, Ben.
>
> On Wed, Jun 05, 2013 at 08:41:01PM -0700, Ben Greear wrote:
>> On 06/05/2013 08:26 PM, Eric Dumazet wrote:
>>> On Wed, 2013-06-05 at 20:14 -0700, Tejun Heo wrote:
>>>> Ah, so, that's why it's showing up now.  We probably have had the same
>>>> issue all along but it used to be masked by the softirq limiting.  Do
>>>> you care to revive the 10 iterations limit so that it's limited by
>>>> both the count and timing?  We do wanna find out why softirq is
>>>> spinning indefinitely tho.
>>>
>>> Yes, no problem, I can do that.
>>
>> Limiting it to 5000 fixes my problem, so if you wanted it larger than 10, that would
>> be fine by me.
>
> First of all, kudos for tracking the issue down.  While the removal of
> looping limit in softirq handling was the direct cause for making the
> problem visible, it's very bothering that we have softirq runaway.
> Finding out the perpetrator shouldn't be hard.  Something like the
> following should work (untested).  Once we know which softirq (prolly
> the network one), we can dig deeper.

The patch below assumes my fix is not in the code, right?

I'll work on this, but it will probably be next week before
I have time...gotta catch up on some other things first.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

