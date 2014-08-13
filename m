Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880AbaHMEED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 00:04:03 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44667 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaHMEEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 00:04:01 -0400
Message-ID: <53EAE3AD.9040203@linaro.org>
Date: Tue, 12 Aug 2014 21:03:57 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: ksummit-discuss@lists.linuxfoundation.org,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-discuss] 2038 Kernel Summit Discussion Fodder
References: <CALAqxLUcfaJnxdmkn6mucepNk3QaCQdcSPLRjjeKsk_OTp=uLA@mail.gmail.com> <1407895613.3017.138.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1407895613.3017.138.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2014 07:06 PM, Ben Hutchings wrote:
> On Tue, 2014-08-12 at 17:01 -0700, John Stultz wrote:
> [...]
>> The downsides here are many. The distros will probably hate this idea,
> I certainly hate the idea of adding another 32-bit port to Debian.
> I think that it's OK for traditional distros to say 'just upgrade to
> 64bit' while you solve the problem for 32-bit embedded systems where
> there's probably little demand for supporting multiple ABIs at once.

So I don't necessarily disagree, but if the rule really is "we don't
break userspace" we will need a solution that at least allows for
multiple ABIs from the kernel side, and we can then let distros chose if
they want to handle both or not.  Even in the embedded world, as usage
grows with things like Android, we're starting to see more strict needs
for ABI/platform stability (see the ARMv8 SWP discussion from last
month).  Fancy android based dashboard infotainment systems probably
want to both be 2038 safe and run today's unsafe applications (hoping
that they get upgraded eventually).


>
>>  as it requires rebuilding the world, and maintaining another legacy
>> architecture support. I’m also not completely sure how robust
>> multi-arch packaging is in the face of having to handle 3-4
>> architectures on one system.
> dpkg multiarch covers this just fine, while I believe RPM is limited to
> biarch.
>
>> On the kernel side, it also adds more complexity, where we have to add
>> even more complex compat support for 64bit systems to handle all the
>> various 32bit applications possible.
> [...]
>
> Didn't we need to do this already to support x32?  Have compat ioctls
> involving time been botched?
I'm not sure exactly what you mean here, but yea, its very much like
supporting something like x32, but its one more to the list and has to
be supported on both 32 and 64 architectures.

thanks
-john

