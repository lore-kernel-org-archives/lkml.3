Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3JAKAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 06:00:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab3JAKAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 06:00:43 -0400
Message-ID: <524A9D46.8050905@suse.de>
Date: Tue, 01 Oct 2013 12:00:38 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120306 Thunderbird/10.0.3
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
Cc: Gleb Natapov <gleb@redhat.com>, Michael Ellerman <michael@ellerman.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au> <1380177066-3835-3-git-send-email-michael@ellerman.id.au> <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia> <20131001083908.GA17294@redhat.com> <20131001092320.GA2000@iris.ozlabs.ibm.com>
In-Reply-To: <20131001092320.GA2000@iris.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 11:23 AM, Paul Mackerras wrote:
> On Tue, Oct 01, 2013 at 11:39:08AM +0300, Gleb Natapov wrote:
>> On Tue, Oct 01, 2013 at 06:34:26PM +1000, Michael Ellerman wrote:
>>> On Thu, Sep 26, 2013 at 11:06:59AM +0200, Paolo Bonzini wrote:
>>>> Il 26/09/2013 08:31, Michael Ellerman ha scritto:
>>>>> Some powernv systems include a hwrng. Guests can access it via the
>>>>> H_RANDOM hcall.
>>>> Is there any reason to do this in the kernel?
>>> It's less code, and it's faster :)
>>>
>>>> It does not have to be a particularly fast path;
>>> Sure, but do we have to make it slow on purpose?
>>>
>> We do not put non performance critical devices into the kernel.
> It's not a device, it's a single hypercall, specified by PAPR, which
> is the moral equivalent of x86's RDRAND.

Yes, and hypercalls should be handled in user space unless impossible 
otherwise (like MMU hypercalls which modify state that user space has no 
priviledge to access).

I think the most reasonable way forward would be to implement the path 
that jumps through hoops and goes through user space, then add a new 
device in kvm that registers on this hcall inside of kvm.

That way we ensure consistency (user space knows what to put into device 
tree, can disable it if it wants to, can run with TCG, etc) and you can 
prove that your user space interface works along the way.


Alex

