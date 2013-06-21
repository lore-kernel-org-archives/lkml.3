Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946134Ab3FUVaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:30:30 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36172 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946079Ab3FUVa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:30:29 -0400
Message-ID: <51C4C5F3.3050800@sgi.com>
Date: Fri, 21 Jun 2013 14:30:27 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Zimmer <nzimmer@sgi.com>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com> <20130621185056.GA23473@kroah.com>
In-Reply-To: <20130621185056.GA23473@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/21/2013 11:50 AM, Greg KH wrote:
> On Fri, Jun 21, 2013 at 11:44:22AM -0700, Yinghai Lu wrote:
>> On Fri, Jun 21, 2013 at 10:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 06/21/2013 09:51 AM, Greg KH wrote:
>>>
>>> I suspect the cutoff for this should be a lot lower than 8 TB even, more
>>> like 128 GB or so.  The only concern is to not set the cutoff so low
>>> that we can end up running out of memory or with suboptimal NUMA
>>> placement just because of this.
>>
>> I would suggest another way:
>> only boot the system with boot node (include cpu, ram and pci root buses).
>> then after boot, could add other nodes.
> 
> What exactly do you mean by "after boot"?  Often, the boot process of
> userspace needs those additional cpus and ram in order to initialize
> everything (like the pci devices) properly.

Exactly.  That's why I left both low and high memory on each node.

> 
> thanks,
> 
> greg k-h
> 
