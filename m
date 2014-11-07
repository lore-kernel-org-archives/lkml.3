Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaKGNiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:38:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaKGNiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:38:19 -0500
Message-ID: <545CCB49.2010405@suse.cz>
Date: Fri, 07 Nov 2014 14:38:17 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at> <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com> <20141105001026.GQ13232@auth.logic.tuwien.ac.at> <20141105001243.GR13232@auth.logic.tuwien.ac.at> <alpine.DEB.2.10.1411041615270.5391@chino.kir.corp.google.com> <545B68C9.2060107@suse.cz> <20141106123904.GU11838@auth.logic.tuwien.ac.at> <545B71A8.6030209@suse.cz> <20141107130717.GF11838@auth.logic.tuwien.ac.at>
In-Reply-To: <20141107130717.GF11838@auth.logic.tuwien.ac.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 02:07 PM, Norbert Preining wrote:
> Hi Vlastimil,
>
> On Thu, 06 Nov 2014, Vlastimil Babka wrote:
>> OK, one possibility is to do (it should apply cleanly)
>> git revert e14c720efdd73c6d69cd8d07fa894bcd11fe1973
>
> I am running with this reverted now, and I cannot reproduce the
> khugepage going overboard anymore.

Great, that's good news if I understand correctly, but ...

> I tried hard since 2 days now, no chance to reproduce.
> Before firefox or shotwell went into boom mode, but not now.
> (For now!)

I suggested the commit to you for revert 1 day ago, and you say you 
can't reproduce it for 2 days already? That's a bit suspicious. Did you 
already tried to revert it before my suggestion, or were you unable to 
reproduce it anymore even before the revert?

>>> Again, as I mentioned, I don't have /proc/pid/stack for any "pid", is
>>> this depending on some specific kerenl option?
>>
>> Ah I missed that. Should be CONFIG_STACKTRACE to enable that.
>
> If you want, I can compile a "default" kernel without the above commit

Hmm it would probably be more useful if I sent you some debug printing 
patches first... the stacktrace won't probably tell us much we don't 
already know.

> reverted, and turn on STACKTRACE (I have turned it one for *all* future
> kernels I compile ;-)

Yeah that's a good idea :)

> I also didn't try the patch you send me, just the revert from above.

Yeah if the revert helped, the other patch probably wouldn't change 
anything. It also didn't help the other guy with similar problem.

> Please let me know which other experiments you want to see.

I'll prepare a debugging patch and send with instructions. Meanwhile you 
could send the /proc/zoneinfo contents? :)

Thanks!
Vlastimil

> Thanks
>
> Norbert
>
> ------------------------------------------------------------------------
> PREINING, Norbert                               http://www.preining.info
> JAIST, Japan                                 TeX Live & Debian Developer
> GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
> ------------------------------------------------------------------------
>

