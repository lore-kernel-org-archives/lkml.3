Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbbAHSTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:19:41 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:54528 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbbAHSTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:19:39 -0500
Message-ID: <54AECA32.6000304@landley.net>
Date: Thu, 08 Jan 2015 12:19:30 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
CC: initramfs <initramfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 6/9] gen_initramfs_list.sh: include xattrs
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>	 <1420663980-20842-7-git-send-email-zohar@linux.vnet.ibm.com>	 <CA+5PVA77x2W9LyHMq1jSW3HKqNgFPz-gPVOH0QtEmmMBwzOx_Q@mail.gmail.com> <1420729994.6338.52.camel@dhcp-9-2-203-236.watson.ibm.com>
In-Reply-To: <1420729994.6338.52.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 09:13 AM, Mimi Zohar wrote:
> On Thu, 2015-01-08 at 09:01 -0500, Josh Boyer wrote: 
>> On Wed, Jan 7, 2015 at 3:52 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> That's pretty awkward.  I think it highlights the major downside of
>> this approach in that from a standard distro point of view this
>> functionality isn't likely to be used.  Do you foresee this feature as
>> something that should be widely used, or something that would be used
>> more in custom, locked-down machines?
> 
> Before distros can start enabling these features, software packages need
> to come with file signatures.  Fin Gunter posted (and shortly will
> re-post) patches to include file signatures in RPM patches.

My personal lack of caring about Red Hat's bureaucratic "signing
binaries in triplicate" is probably large enough to be seen from space
(obviously no vendor code has ever contained an exploit that could be
used to run arbitrary code in ring 0, and this totally won't be used for
vendor lock-in, but I remain unconvinced because I'm funny that way)...

But I am curious about how you propose to encode xattrs into the cpio
format. (Which Al Viro chose because it's _simple_. There isn't really a
controlling spec since Posix decided to deprecated it in 2001 and  yank
it from SUSv3 onwards. LSB extended several header fields to 8 hex
digits instead of 6, but they still have 32 bit timestamps which seems a
bit short-sighted. If you're going to define a new rev with a new magic
number, there are a couple other things you might wanna fix...)

I ask because I maintain a new from-scratch cpio implementation
(http://landley.net/hg/toybox/file/1571/toys/posix/cpio.c), so I'd
presumably have to add your format extensions to this. Is there any sort
of documentation on them?

The toybox config Android is using has this cpio implementation enabled
(see
https://android.googlesource.com/platform/external/toybox/+/9250c95a8c47/Android.mk)
so I'd rather like to get this sort of detail right...

> Including file signatures in RPM packages (and similarly in other
> software package formats) is the direction we, the linux community, IMHO
> should be moving.  How long this will take is entirely up to the
> distros.

Glued down to a trusted platform module such that obviously nobody can
possibly exploit such a system, from
https://www.youtube.com/watch?v=4loZGYqaZ7I to
https://trmm.net/Thunderstrike_31c3

I see this as way, way more about vendor lock-in than security.

>> I can understand not wanting to redefine the newc format in userspace
>> cpio, but if you want this to be easier to use then perhaps working
>> with dracut upstream to make it support this out of the box would be a
>> good idea.
> 
> Anyone using dracut/systemd is currently not using tmpfs, as specifying
> "root=" on the boot command line reverts to using ramfs.  Rob Landley
> suggested userspace apps use "ROOT=" instead.
> (http://sourceforge.net/p/linux-ima/mailman/message/33189705/)

I'm working on a documentation update, but the old docs I wrote have
gone a bit stale in a number of places so I'm not done yet...

> This patch set was posted as an RFC.  Assuming this solution for
> including xattrs in the rootfs is acceptable, I'll post the
> dracut/systemd changes.

(I'm not particularly interested in systemd either, but good luck with
that...)

> Mimi

Rob
