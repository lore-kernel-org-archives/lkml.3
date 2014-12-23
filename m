Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbaLWPO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:14:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958AbaLWPOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:14:25 -0500
Message-ID: <549986C3.4060807@redhat.com>
Date: Tue, 23 Dec 2014 16:14:11 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC 2/2] x86, vdso, pvclock: Simplify and speed
 up the vdso pvclock reader
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net> <549986B8.3030606@oracle.com>
In-Reply-To: <549986B8.3030606@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/12/2014 16:14, Boris Ostrovsky wrote:
>> +    do {
>> +        version = pvti->version;
>> +
>> +        /* This is also a read barrier, so we'll read version first. */
>> +        rdtsc_barrier();
>> +        tsc = __native_read_tsc();
> 
> 
> This will cause VMEXIT on Xen with TSC_MODE_ALWAYS_EMULATE which is
> used, for example, after guest migrated (unless HW is capable of scaling
> TSC rate).

So does the __pvclock_read_cycles this is replacing (via
pvclock_get_nsec_offset).

Paolo
