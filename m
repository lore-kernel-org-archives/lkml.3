Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3A3SUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:20:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52485 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab3A3SUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:20:44 -0500
Message-ID: <5109641A.5040707@zytor.com>
Date: Wed, 30 Jan 2013 10:19:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: Jan Beulich <JBeulich@suse.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "bp@alien8.de" <bp@alien8.de>, "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
References: <1359507077-26050-1-git-send-email-kys@microsoft.com> <1359507108-26091-1-git-send-email-kys@microsoft.com> <1359507108-26091-2-git-send-email-kys@microsoft.com> <5108ED9702000078000BAA08@nat28.tlf.novell.com> <1db4d98aa3434d4eab7b36bbeb89cd47@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <1db4d98aa3434d4eab7b36bbeb89cd47@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 10:12 AM, KY Srinivasan wrote:
>>
>> I'm not convinced that's the right approach - any hypervisor
>> could do similar emulation, and hence you either want to make
>> sure you run on Hyper-V (by excluding all others), or you
>> tolerate using the emulation (which may require syncing up with
>> the other guest implementations so that shared resources don't
>> get used by two parties).
>>
>> I also wonder whether using the Hyper-V emulation (where
>> useful, there might not be anything right now, but this may
>> change going forward) when no Xen support is configured
>> wouldn't be better than not using anything...
>
> Jan,
>
> Presumably, Hyper-V emulation is only to run enlightened Windows. The issue with
> Xen is not that it emulates Hyper-V, but this emulation is turned on while running Linux.
> That is the reason I chose to check for Xen. Would you prefer a DMI check for the Hyper-V
> platform.
>

The real issue here is anyone going to run a kernel:

1. which has Xen support *disabled*,
2. which has HyperV support *enabled*,
3. on top of Xen,
4. with Xen HyperV support enabled.

The fundamental problem seems to be that Xen HyperV support is "just 
good enough to run Windows", but in fact has some serious shortcomings 
which breaks Linux guests that don't have Xen support (if they do, the 
Xen support kicks in instead.)

Am I right?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

