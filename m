Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaKUV61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:58:27 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60943 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaKUV6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:58:25 -0500
Message-ID: <546FB57B.3000303@redhat.com>
Date: Fri, 21 Nov 2014 22:58:19 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel,gmane.linux.kernel.stable
To: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
CC: Wanpeng Li <wanpeng.li@linux.intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        stable@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>
Subject: Re: [CFT PATCH 2/2] KVM: x86: support XSAVES usage in the host
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com> <1416594678-13011-3-git-send-email-pbonzini@redhat.com> <546F9B59.7060800@amacapital.net>
In-Reply-To: <546F9B59.7060800@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/11/2014 21:06, Andy Lutomirski wrote:
>> > +			cpuid_count(XSTATE_CPUID, index,
>> > +				    &size, &offset, &ecx, &edx);
>> > +	                memcpy(dest + offset, src, size);
> Is this really the best way to do this?  cpuid is serializing, so this
> is possibly *very* slow.

The data is in arch/x86/kernel/xsave.c, but it is not exported.  But
this is absolutely not a hotspot.

Paolo
