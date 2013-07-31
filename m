Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab3GaJrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:47:14 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:57968 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759092Ab3GaJrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:47:10 -0400
Message-ID: <51F8DCFC.9050205@linux.vnet.ibm.com>
Date: Wed, 31 Jul 2013 15:16:36 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Joe Perches <joe@perches.com>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
References: <1374526866-6813-1-git-send-email-bp@alien8.de> <20130724171347.GB29756@naverao1-tp.watson.ibm.com> <1374686598.18818.18.camel@joe-AO722> <51F10AA8.2050901@linux.vnet.ibm.com> <CAErSpo5vLbsM5BXjrCVy1AKBxRRSH33TthyyK3O35Mghqw81nQ@mail.gmail.com>
In-Reply-To: <CAErSpo5vLbsM5BXjrCVy1AKBxRRSH33TthyyK3O35Mghqw81nQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073109-8256-0000-0000-00000897001C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 11:02 PM, Bjorn Helgaas wrote:
> On Thu, Jul 25, 2013 at 5:23 AM, Naveen N. Rao
> <naveen.n.rao@linux.vnet.ibm.com> wrote:
>> On 07/24/2013 10:53 PM, Joe Perches wrote:
>>>
>>> On Wed, 2013-07-24 at 22:43 +0530, Naveen N. Rao wrote:
>>>>
>>>> On 2013/07/22 11:01PM, Borislav Petkov wrote:
>>>>>
>>>>> From: Borislav Petkov <bp@suse.de>
>>>>>
>>>>> [    5.525861] ERST: Can not request iomem region <0x        c7eff000-0x
>>>>> c7f00000> for ERST.
>>>>>
>>>>> This needs to have leading zeroes. Make it so.
>>>
>>>
>>> Why does it need leading zeros?
>>>
>>>> While looking at this, I noticed that we seem to be using varying field
>>>> widths in our APEI code:
>>>> - einj.c has two instances using %#010llx.
>>>> - apei-base.c uses widths of 10 (4 bytes) and 6 (2 bytes).
>>>>
>>>> Not sure if these are intentional and those fields truly aren't 64-bit
>>>> (as suggested by the usage of long long int).
>>>
>>>
>>> I suggest using "0x%llx" everywhere unless there's a
>>> compelling reason like columnar alignment for them.
>>
>>
>> I think that might be better. I see that these changes were done in commit
>> 46b91e37. Copying Bjorn Helgaas.
>
> As the 46b91e37 changelog says, it was done to use "the normal
> %pR-like format".  I think that's a valid goal.  When we're printing
> the same sort of information, we should use the same sort of format.

Bjorn,
My key question was about why we are using a field width of 10 implying 
a 32-bit value, rather than a field width of 18 as suggested by the data 
type? This shouldn't truncate the value, but if we are specifying the 
field width for alignment, seems to me it is better to match the data type.

Thanks,
Naveen

>
> But I don't think the "Can not request iomem region <0x
> c7eff000-0x        c7f00000> for ERST" output mentioned in the
> original post was affected by 46b91e37.  I would suggest a change
> similar to 46b91e37 for ERST, and I would suggest using the leading
> zeros, with %#010llx for physical memory addresses and %#06llx for
> ioport addresses.  That's what %pR uses, and it produces columnar
> alignment in many cases (though not this one).
>
> Bjorn
>

