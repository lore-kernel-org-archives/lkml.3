Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaLWPXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:23:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38606 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLWPXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:23:51 -0500
Message-ID: <5499897D.3000904@oracle.com>
Date: Tue, 23 Dec 2014 10:25:49 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC 2/2] x86, vdso, pvclock: Simplify and speed
 up the vdso pvclock reader
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net> <549986B8.3030606@oracle.com> <549986C3.4060807@redhat.com>
In-Reply-To: <549986C3.4060807@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2014 10:14 AM, Paolo Bonzini wrote:
>
> On 23/12/2014 16:14, Boris Ostrovsky wrote:
>>> +    do {
>>> +        version = pvti->version;
>>> +
>>> +        /* This is also a read barrier, so we'll read version first. */
>>> +        rdtsc_barrier();
>>> +        tsc = __native_read_tsc();
>>
>> This will cause VMEXIT on Xen with TSC_MODE_ALWAYS_EMULATE which is
>> used, for example, after guest migrated (unless HW is capable of scaling
>> TSC rate).
> So does the __pvclock_read_cycles this is replacing (via
> pvclock_get_nsec_offset).

Right, I didn't notice that.

-boris
