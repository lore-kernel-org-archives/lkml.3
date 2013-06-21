Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423749Ab3FUTTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:19:00 -0400
Received: from relay1.sgi.com ([192.48.179.29]:46956 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423686Ab3FUTS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:18:58 -0400
Message-ID: <51C4A726.1090300@sgi.com>
Date: Fri, 21 Jun 2013 14:19:02 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Robin Holt <holt@sgi.com>, Mike Travis <travis@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com> <20130621185056.GA23473@kroah.com> <CAE9FiQVt7Fa5oTYR+yLsehboPMo86vEDsRUaqNLQD9fizD5=Fg@mail.gmail.com>
In-Reply-To: <CAE9FiQVt7Fa5oTYR+yLsehboPMo86vEDsRUaqNLQD9fizD5=Fg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 02:10 PM, Yinghai Lu wrote:
> On Fri, Jun 21, 2013 at 11:50 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Fri, Jun 21, 2013 at 11:44:22AM -0700, Yinghai Lu wrote:
>>> On Fri, Jun 21, 2013 at 10:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> On 06/21/2013 09:51 AM, Greg KH wrote:
>>>>
>>>> I suspect the cutoff for this should be a lot lower than 8 TB even, more
>>>> like 128 GB or so.  The only concern is to not set the cutoff so low
>>>> that we can end up running out of memory or with suboptimal NUMA
>>>> placement just because of this.
>>> I would suggest another way:
>>> only boot the system with boot node (include cpu, ram and pci root buses).
>>> then after boot, could add other nodes.
>> What exactly do you mean by "after boot"?  Often, the boot process of
>> userspace needs those additional cpus and ram in order to initialize
>> everything (like the pci devices) properly.
> I mean for Intel cpu have cpu and memory controller and IIO.
> every IIO is one peer pci root bus.
> So scan root bus that are not with boot node later.
>
> in this way we can keep all numa etc on the place when online ram, cpu, pci...
>
> For example if we have 32 sockets system, most time for boot is with *BIOS*
> instead of OS. In those kind of system boot is like this way:
> only first two sockets get booted from bios to OS.
> later use hot add every other two sockets.
>
> that will also make BIOS simpler, and it need to support hot-add for
> services purpose anyway.
>
> Yinghai

Yes the hot add path was one option we looked at and it did shorten boot 
times but the goal I had here is to get from power on to having the full 
machine available as quick as possible. Several clients need significant 
portions of ram for their key workloads.  So that guided my thoughts on 
this patch.
