Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaH0H6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:58:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbaH0H6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:58:52 -0400
Message-ID: <53FD8FBA.1040203@suse.com>
Date: Wed, 27 Aug 2014 09:58:50 +0200
From: =?ISO-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dexuan Cui <decui@microsoft.com>, Jan Beulich <JBeulich@suse.com>
CC: "jeremy@goop.org" <jeremy@goop.org>, KY Srinivasan <kys@microsoft.com>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sync_set_bit() vs set_bit()  -- what's the difference?
References: <EE124450C0AAF944A40DD71E61F878C99639F3@SINEX14MBXC419.southpacific.corp.microsoft.com> <53FDA71B020000780002DF2E@mail.emea.novell.com> <EE124450C0AAF944A40DD71E61F878C9963AA0@SINEX14MBXC419.southpacific.corp.microsoft.com>
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C9963AA0@SINEX14MBXC419.southpacific.corp.microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 09:50 AM, Dexuan Cui wrote:
>> -----Original Message-----
>> From: Jan Beulich
>> Sent: Wednesday, August 27, 2014 15:39 PM
>>>>> On 27.08.14 at 09:30, <decui@microsoft.com> wrote:
>>> I'm curious about the difference. :-)
>>>
>>> sync_set_bit() is only used in drivers/hv/ and drivers/xen/ while set_bit()
>>> is used in all other places. What makes hv/xen special?
>>
>> I guess this would really want to be used by anything communicating
>> with a hypervisor or a remote driver: set_bit() gets its LOCK prefix
>> discarded when the local kernel determines it runs on a single CPU
>> only. Obviously having knowledge of the CPU count inside a VM does
>> not imply anything about the number of CPUs available to the host,
>> i.e. stripping LOCK prefixes in that case would be unsafe.
>>
>> Jan
>
> Thank you, Juergen and Jan for your  quick answers!
>
> I didn't realize LOCK_PREFIX is "" for UP. :-)

Even worse: it is patched away dynamically when you disable all but one
processor and activated again when a second processor is becoming
active.


Juergen

