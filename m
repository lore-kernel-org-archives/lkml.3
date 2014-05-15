Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaEOUdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:33:21 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755935AbaEOUdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:33:20 -0400
Message-ID: <53752487.3060303@nod.at>
Date: Thu, 15 May 2014 22:33:11 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "Michael H. Warfield" <mhw@wittsend.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        James.Bottomley@HansenPartnership.com
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com> <20140515013245.GA1764@kroah.com> <1400120251.7699.11.camel@canyon.ip6.wittsend.com> <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com> <1400161337.7699.33.camel@canyon.ip6.wittsend.com> <20140515140856.GA17453@kroah.com> <CAFLxGvwfbVdLUq0NrSrQNYH+bTzYLuCE2moooHH319qRfDkS6Q@mail.gmail.com> <20140515195010.GA22317@ubuntumail> <53751FFA.5040103@nod.at> <20140515202628.GB25896@mail.hallyn.com>
In-Reply-To: <20140515202628.GB25896@mail.hallyn.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.05.2014 22:26, schrieb Serge E. Hallyn:
> Quoting Richard Weinberger (richard@nod.at):
>> Am 15.05.2014 21:50, schrieb Serge Hallyn:
>>> Quoting Richard Weinberger (richard.weinberger@gmail.com):
>>>> On Thu, May 15, 2014 at 4:08 PM, Greg Kroah-Hartman
>>>> <gregkh@linuxfoundation.org> wrote:
>>>>> Then don't use a container to build such a thing, or fix the build
>>>>> scripts to not do that :)
>>>>
>>>> I second this.
>>>> To me it looks like some folks try to (ab)use Linux containers
>>>> for purposes where KVM would much better fit in.
>>>> Please don't put more complexity into containers. They are already
>>>> horrible complex
>>>> and error prone.
>>>
>>> I, naturally, disagree :)  The only use case which is inherently not
>>> valid for containers is running a kernel.  Practically speaking there
>>> are other things which likely will never be possible, but if someone
>>> offers a way to do something in containers, "you can't do that in
>>> containers" is not an apropos response.
>>>
>>> "That abstraction is wrong" is certainly valid, as when vpids were
>>> originally proposed and rejected, resulting in the development of
>>> pid namespaces.  "We have to work out (x) first" can be valid (and
>>> I can think of examples here), assuming it's not just trying to hide
>>> behind a catch-22/chicken-egg problem.
>>>
>>> Finally, saying "containers are complex and error prone" is conflating
>>> several large suites of userspace code and many kernel features which
>>> support them.  Being more precise would, if the argument is valid,
>>> lend it a lot more weight.
>>
>> We (my company) use Linux containers since 2011 in production. First LXC, now libvirt-lxc.
>> To understand the internals better I also wrote my own userspace to create/start
>> containers. There are so many things which can hurt you badly.
>> With user namespaces we expose a really big attack surface to regular users.
>> I.e. Suddenly a user is allowed to mount filesystems.
> 
> That is currently not the case.  They can mount some virtual filesystems
> and do bind mounts, but cannot mount most real filesystems.  This keeps
> us protected (for now) from potentially unsafe superblock readers in the
> kernel.

Yeah, I meant not only "real" filesystems.
I had VFS issues in mind where an attacker could do bad things
using bind mounts for example.

>> Ask Andy, he found already lots of nasty things...
> 
> Yes, of course, and there may be more to come...
> 
>> I agree that user namespaces are the way to go, all the papering with LSM
>> over security issues is much worse.
>> But we have to make sure that we don't add too much features too fast.
> 
> Agreed.  Like I said, 'we have to work (x) out first' could be valid,
> including 'we should wait (a year?) for user ns issues to fall out
> before relaxing any of the current user ns constraints." 
> 
> On the other hand, not exercising the new code may only mean that
> existing flaws stick around longer, undetected (by most).

Fair point.

>> That said, I like containers a lot because they are cheap but as they are lightweight
>> also therefore also isolation level is lightweight.
>> IMHO containers are not a cheap replacement for KVM.
> 
> The building blocks for containers can also be used for entirely
> new, simpler use cases - i.e. perhaps a new fakeroot alternative based
> on user namespace mappings.  Which is why "this is not a use case for
> containers" is not the right way to push back, whether or not the
> feature ends up being appropriate.

Agreed.

Maybe I'm too pessimistic.
We'll see. :-)

Thanks,
//richard
