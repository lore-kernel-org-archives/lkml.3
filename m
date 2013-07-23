Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab3GWSqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:46:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34200 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598Ab3GWSqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:46:12 -0400
Message-ID: <51EECF5F.8000901@zytor.com>
Date: Tue, 23 Jul 2013 11:45:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: Jason Wang <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@redhat.com" <gleb@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <1374572465-15278-4-git-send-email-jasowang@redhat.com> <bd93bc49300a4d99996cc4f57c19a008@SN2PR03MB061.namprd03.prod.outlook.com> <51EE97BD.4050402@zytor.com> <e31a95e22bbc4c8dbbf76f88b8c90581@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <e31a95e22bbc4c8dbbf76f88b8c90581@SN2PR03MB061.namprd03.prod.outlook.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 10:45 AM, KY Srinivasan wrote:
>>
>> One strategy would be to pick the *last* one in the CPUID list, since
>> the ones before it are logically the one(s) being emulated...
> 
> Is it always possible to guarantee this ordering. As a hypothetical, what if hypervisor A
> emulates Hypervisor B and Hypervisor B emulates Hypervisor A. In this case we cannot
> have any "order" based detection that can yield "correct" detection. I define "correctness"
> as follows:
> 
> If a guest can run on both the hypervisors, the guest should detect the true native
> Hypervisor. 
> 

My point was that most hypervisors tend to put the native signature at
the end of the list starting at 0x40000000, just to deal with naïve
guests which only look at 0x40000000 and not beyond.  So a natural
convention would be to "use the last entry in the list you know how to
handle."

	-hpa


