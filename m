Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422659AbaDJTSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:18:02 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40277 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965783AbaDJTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:17:53 -0400
Message-ID: <5346EE5D.2020503@amacapital.net>
Date: Thu, 10 Apr 2014 12:17:49 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Florian Weimer <fweimer@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>, linux-kernel@vger.kernel.org
CC: Hugh Dickins <hughd@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
        john.stultz@linaro.org, Greg Kroah-Hartman <greg@kroah.com>,
        Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com> <5343F2EC.3050508@redhat.com>
In-Reply-To: <5343F2EC.3050508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 06:00 AM, Florian Weimer wrote:
> On 03/19/2014 08:06 PM, David Herrmann wrote:
> 
>> Unlike existing techniques that provide similar protection, sealing
>> allows
>> file-sharing without any trust-relationship. This is enforced by
>> rejecting seal
>> modifications if you don't own an exclusive reference to the given
>> file. So if
>> you own a file-descriptor, you can be sure that no-one besides you can
>> modify
>> the seals on the given file. This allows mapping shared files from
>> untrusted
>> parties without the fear of the file getting truncated or modified by an
>> attacker.
> 
> How do you keep these promises on network and FUSE file systems?  Surely
> there is still some trust involved for such descriptors?
> 
> What happens if you create a loop device on a sealed descriptor?
> 
> Why does memfd_create not create a file backed by a memory region in the
> current process?  Wouldn't this be a far more generic primitive?
> Creating aliases of memory regions would be interesting for many things
> (not just libffi bypassing SELinux-enforced NX restrictions :-).

If you write a patch to prevent selinux from enforcing NX, I will ack
that patch with all my might.  I don't know how far it would get me, but
I think that selinux has no business going anywhere near execmem.

Adding a clone mode to mremap might be a better bet.  But memfd solves
that problem, too, albeit messily.

--Andy
