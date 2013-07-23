Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3GWFrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:47:09 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54060 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3GWFrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <51EE1765.2000402@nod.at>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
	<51E988FF.9010201@nod.at>
	<CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
	<CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
	<51ED0BBF.7060502@nod.at>
	<CALkWK0mpH9XHL2PZK47Lb9frf9hFNQ8sjF2_0p7VJnY8XWhiGw@mail.gmail.com>
	<20130722223238.GC13191@tango.0pointer.de>
	<51EE1765.2000402@nod.at>
Date: Tue, 23 Jul 2013 07:47:07 +0200
Message-ID: <CAFLxGvx0-TA7R5d6ienSiRm+rrGtCyf_LU5BNTAn1t7U9Ji8Jw@mail.gmail.com>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Al again, someone dropped him from the CC list...

On Tue, Jul 23, 2013 at 7:40 AM, Richard Weinberger <richard@nod.at> wrote:
> Lennart,
>
> Am 23.07.2013 00:32, schrieb Lennart Poettering:
>> On Mon, 22.07.13 16:13, Ramkumar Ramachandra (artagnon@gmail.com) wrote:
>>
>>>
>>> [Corrected Lennart's email ID]
>>>
>>> Richard Weinberger wrote:
>>>> CC'ing Lennart.
>>>>
>>>> Am 22.07.2013 11:45, schrieb Ramkumar Ramachandra:
>>>>> Ramkumar Ramachandra wrote:
>>>>>> [1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012152.html
>>>>>
>>>>> ... and the patches were rejected.  Lennart says that UML providing
>>>>> /dev/tty* is wrong, and that UML should call them /dev/hvc* (or
>>>>> something).  Can we do something about the situation?  Can we remove
>>>>> /dev/tty*, and provide /dev/hvc*?  Will we be breaking existing users?
>>>>>
>>>>> Thanks.
>>>>>
>>>>> Lennart Poettering wrote:
>>>>>> UML shouldn't be penalized for not implementing some terminal emulation,
>>>>>> but it should be penalized for doing so under the label of "VT support",
>>>>>> which it simply is not providing.
>>>>>>
>>>>>> They can call their ttys any way they want. If the call them
>>>>>> /dev/tty[1..64] however, then they need to implement the VC
>>>>>> interfaces. All of them.
>>>>
>>>> Lennart, can you please explain us why /dev/tty[1..64] is forced to
>>>> have virtual console support?
>>
>> /dev/tty[1..64] is the userspace API to the kernel VT subsystem. If you
>> support it you need to match up all /dev/tty[1..64] with a
>> /dev/vcs[1..64] + /dev/vcsa[1..64]. You need to expose a tty that
>> understands TERM=linux and the ioctls listed on console_ioctl(4). You
>> need /dev/tty0 as something that behaves like a symlink to the fg
>> VT. You should also support files like /sys/class/tty/tty0/active with
>> its POLLHUP iface.
>
> I sightly disagree with you.
> /dev/tty[1..64] is not directly bound to VT.
> You can have systems with CONFIG_VT=n and still have /dev/tty[1..64].
> Linux supports this perfectly.
> UML does not have VT because having virtual consoles makes no sense.
> (Same like on s390)
>
> Thanks,
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
Thanks,
//richard
