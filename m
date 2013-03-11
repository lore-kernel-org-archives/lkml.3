Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab3CKUVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:21:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45772 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab3CKUVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:21:37 -0400
Message-ID: <513E3C44.9030402@zytor.com>
Date: Mon, 11 Mar 2013 13:19:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
References: <20130311144853.GB8482@redhat.com> <20130311150256.GC8482@redhat.com> <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com> <20130311182655.GB12107@redhat.com> <513E2695.3080707@zytor.com> <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com> <513E28B8.3000502@zytor.com> <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com> <20130311192021.GF12107@redhat.com> <513E36CB.5040908@zytor.com> <20130311201245.GC14738@redhat.com>
In-Reply-To: <20130311201245.GC14738@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 01:12 PM, Vivek Goyal wrote:
>>
>> Quite frankly the whole design seems to be held together with chewing
>> gum.  At the core, the problem is a tight coupling between kexec-tools
>> version, kexec-tools options, and kernel command line options that have
>> to be combined in very ugly ways.  Part of the reason is that the kernel
>> isn't actually given the information it needs to do the job required.
>>
>> As far as "if a user wants to load"... why on Earth should that be the
>> default?  How could that *not* be an exceptional case?
> 
> Because it breaks existing user cases. We had this limitation so far
> that bzImage has to be loaded in first 896MB. And for 32bit bzImage
> entry, I think that is still true?
> 
> So how can kernel assume that user is always loading a 64bit bzImage
> and reserve memory accordingly.
> 
> Also in the past we did not have relocatable kernel and memory had to
> be reserved at the address new kernel is built. Thankfully that is
> no more the case.
> 

The problem with this argument here is that we are spiraling down the
drain of increasing user-visible complexity in order to not break
existing but exotic use cases.  We need to stop and reverse this trend.
 I want to make a few observations on this:

1. Running with an archaic kexec-tools should be considered an anomaly.
 If necessary, we could introduce a kernel option to let the kernel know
which kexec-tools version the user will use.

2. As long as memory is available, there is always the option to shift
memory around to accommodate the crashkernel.  That probably should have
been done all along.

3. The memory size reserved should be deduced automatically to the
greatest possible extent.

	-hpa

