Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab3GXEhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:37:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab3GXEhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:37:54 -0400
Message-ID: <51EF59FB.8040207@redhat.com>
Date: Wed, 24 Jul 2013 12:37:15 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: KY Srinivasan <kys@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@redhat.com" <gleb@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <1374572465-15278-4-git-send-email-jasowang@redhat.com> <bd93bc49300a4d99996cc4f57c19a008@SN2PR03MB061.namprd03.prod.outlook.com> <51EE97BD.4050402@zytor.com>
In-Reply-To: <51EE97BD.4050402@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 10:48 PM, H. Peter Anvin wrote:
> On 07/23/2013 06:55 AM, KY Srinivasan wrote:
>> This strategy of hypervisor detection based on some detection order IMHO is not
>> a robust detection strategy. The current scheme works since the only hypervisor emulated
>> (by other hypervisors happens to be Hyper-V). What if this were to change.
>>
> One strategy would be to pick the *last* one in the CPUID list, since
> the ones before it are logically the one(s) being emulated...
>
> 	-hpa
>

How about simply does a reverse loop from 0x40010000 to 0x40010000?
