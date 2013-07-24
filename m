Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3GXQsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:48:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48431 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab3GXQsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:48:47 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <ddd4ff1d4b124faeb18e6a0ba8ae2128@BLUPR03MB050.namprd03.prod.outlook.com>
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <1374572465-15278-4-git-send-email-jasowang@redhat.com> <bd93bc49300a4d99996cc4f57c19a008@SN2PR03MB061.namprd03.prod.outlook.com> <51EE97BD.4050402@zytor.com> <51EF59FB.8040207@redhat.com> <51EF5C9C.6070403@zytor.com> <51EF7A2A.6040003@redhat.com> <51EF7CFB.8030104@redhat.com> <ddd4ff1d4b124faeb18e6a0ba8ae2128@BLUPR03MB050.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: RE: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 24 Jul 2013 08:14:13 -0700
To: KY Srinivasan <kys@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <ba894640-b367-44f0-a5e2-89a2edf4951a@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see how this solves the A emulates B, B emulates A problem?

KY Srinivasan <kys@microsoft.com> wrote:
>
>
>> -----Original Message-----
>> From: Paolo Bonzini [mailto:paolo.bonzini@gmail.com] On Behalf Of
>Paolo
>> Bonzini
>> Sent: Wednesday, July 24, 2013 3:07 AM
>> To: Jason Wang
>> Cc: H. Peter Anvin; KY Srinivasan; tglx@linutronix.de;
>mingo@redhat.com;
>> x86@kernel.org; gleb@redhat.com; kvm@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
>> 
>> Il 24/07/2013 08:54, Jason Wang ha scritto:
>> > On 07/24/2013 12:48 PM, H. Peter Anvin wrote:
>> >> On 07/23/2013 09:37 PM, Jason Wang wrote:
>> >>> On 07/23/2013 10:48 PM, H. Peter Anvin wrote:
>> >>>> On 07/23/2013 06:55 AM, KY Srinivasan wrote:
>> >>>>> This strategy of hypervisor detection based on some detection
>order
>> IMHO is not
>> >>>>> a robust detection strategy. The current scheme works since the
>only
>> hypervisor emulated
>> >>>>> (by other hypervisors happens to be Hyper-V). What if this were
>to
>> change.
>> >>>>>
>> >>>> One strategy would be to pick the *last* one in the CPUID list,
>since
>> >>>> the ones before it are logically the one(s) being emulated...
>> >>>>
>> >>>> 	-hpa
>> >>>>
>> >>> How about simply does a reverse loop from 0x40010000 to
>0x40010000?
>> >>>
>> >> Not all systems like being poked too far into hyperspace.  Just
>remember
>> >> the last match and walk the list.
>> >>
>> >> 	-hpa
>> >>
>> >
>> > Ok, but it raises a question - how to know it was the 'last' match
>> > without knowing all signatures of other hyper-visor?
>> 
>> You can return a "priority" value from the .detect function.  The
>> priority value can simply be the CPUID leaf where the signature was
>> found (or a low value such as 1 if detection was done with DMI).
>> 
>> Then you can pick the hypervisor with the highest priority instead of
>> hard-coding the order.
>
>I like this idea; this allows some guest level control that is what we
>want
>when we have hypervisors emulating each other.
>
>
>Regards,
>
>K. Y 
>> 
>> Paolo
>> 
>> 

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
