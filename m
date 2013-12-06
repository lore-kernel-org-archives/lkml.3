Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab3LFVeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:34:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32946 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab3LFVeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:34:12 -0500
Message-ID: <52A242BE.3010701@zytor.com>
Date: Fri, 06 Dec 2013 13:33:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Xudong Hao <xudong.hao@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Qemu-devel] [PATCH v2 3/3] X86,	mpx: Intel MPX xstate feature
 definition
References: <1386375658-2191-1-git-send-email-qiaowei.ren@intel.com>	<1386375658-2191-3-git-send-email-qiaowei.ren@intel.com> <52A20AD6.8080706@redhat.com> <DE8DF0795D48FD4CA783C40EC82923350140B3B6@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350140B3B6@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 12:05 PM, Liu, Jinsong wrote:
>>
>> Since Peter already said the same, please undo these changes.
>>
>> Also, how is XSTATE_EAGER used?  Should MPX be disabled when xsaveopt
>> is disabled on the kernel command line?  (Liu, how would this affect
>> the KVM patches, too?)
>>
>> Paolo
> 
> Currently seems no, and if needed we can add a new patch at kvm side accordingly when native mpx patches checked in.
> 

We need to either disable these features in lazy mode, or we need to
force eager mode if these features are to be supported.  The problem
with the latter is that it means forcing eager mode regardless of if
anything actually *uses* these features.

A third option would be to require applications to use a prctl() or
similar to enable eager-save features.

Thoughts?

	-hpa

