Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3GWFk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:40:57 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751459Ab3GWFk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:40:56 -0400
Message-ID: <51EE1765.2000402@nod.at>
Date: Tue, 23 Jul 2013 07:40:53 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lennart Poettering <mzxreary@0pointer.de>
CC: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com> <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com> <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com> <51ED0BBF.7060502@nod.at> <CALkWK0mpH9XHL2PZK47Lb9frf9hFNQ8sjF2_0p7VJnY8XWhiGw@mail.gmail.com> <20130722223238.GC13191@tango.0pointer.de>
In-Reply-To: <20130722223238.GC13191@tango.0pointer.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart,

Am 23.07.2013 00:32, schrieb Lennart Poettering:
> On Mon, 22.07.13 16:13, Ramkumar Ramachandra (artagnon@gmail.com) wrote:
> 
>>
>> [Corrected Lennart's email ID]
>>
>> Richard Weinberger wrote:
>>> CC'ing Lennart.
>>>
>>> Am 22.07.2013 11:45, schrieb Ramkumar Ramachandra:
>>>> Ramkumar Ramachandra wrote:
>>>>> [1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012152.html
>>>>
>>>> ... and the patches were rejected.  Lennart says that UML providing
>>>> /dev/tty* is wrong, and that UML should call them /dev/hvc* (or
>>>> something).  Can we do something about the situation?  Can we remove
>>>> /dev/tty*, and provide /dev/hvc*?  Will we be breaking existing users?
>>>>
>>>> Thanks.
>>>>
>>>> Lennart Poettering wrote:
>>>>> UML shouldn't be penalized for not implementing some terminal emulation,
>>>>> but it should be penalized for doing so under the label of "VT support",
>>>>> which it simply is not providing.
>>>>>
>>>>> They can call their ttys any way they want. If the call them
>>>>> /dev/tty[1..64] however, then they need to implement the VC
>>>>> interfaces. All of them.
>>>
>>> Lennart, can you please explain us why /dev/tty[1..64] is forced to
>>> have virtual console support?
> 
> /dev/tty[1..64] is the userspace API to the kernel VT subsystem. If you
> support it you need to match up all /dev/tty[1..64] with a
> /dev/vcs[1..64] + /dev/vcsa[1..64]. You need to expose a tty that
> understands TERM=linux and the ioctls listed on console_ioctl(4). You
> need /dev/tty0 as something that behaves like a symlink to the fg
> VT. You should also support files like /sys/class/tty/tty0/active with
> its POLLHUP iface.

I sightly disagree with you.
/dev/tty[1..64] is not directly bound to VT.
You can have systems with CONFIG_VT=n and still have /dev/tty[1..64].
Linux supports this perfectly.
UML does not have VT because having virtual consoles makes no sense.
(Same like on s390)

Thanks,
//richard
