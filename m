Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3GYLXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 07:23:51 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48625 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab3GYLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 07:23:47 -0400
Message-ID: <51F10AA8.2050901@linux.vnet.ibm.com>
Date: Thu, 25 Jul 2013 16:53:20 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Borislav Petkov <bp@alien8.de>,
        bhelgaas@google.com
CC: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
References: <1374526866-6813-1-git-send-email-bp@alien8.de> <20130724171347.GB29756@naverao1-tp.watson.ibm.com> <1374686598.18818.18.camel@joe-AO722>
In-Reply-To: <1374686598.18818.18.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072511-5816-0000-0000-00000916D38B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 10:53 PM, Joe Perches wrote:
> On Wed, 2013-07-24 at 22:43 +0530, Naveen N. Rao wrote:
>> On 2013/07/22 11:01PM, Borislav Petkov wrote:
>>> From: Borislav Petkov <bp@suse.de>
>>>
>>> [    5.525861] ERST: Can not request iomem region <0x        c7eff000-0x        c7f00000> for ERST.
>>>
>>> This needs to have leading zeroes. Make it so.
>
> Why does it need leading zeros?
>
>> While looking at this, I noticed that we seem to be using varying field
>> widths in our APEI code:
>> - einj.c has two instances using %#010llx.
>> - apei-base.c uses widths of 10 (4 bytes) and 6 (2 bytes).
>>
>> Not sure if these are intentional and those fields truly aren't 64-bit
>> (as suggested by the usage of long long int).
>
> I suggest using "0x%llx" everywhere unless there's a
> compelling reason like columnar alignment for them.

I think that might be better. I see that these changes were done in 
commit 46b91e37. Copying Bjorn Helgaas.

On 07/24/2013 11:40 PM, Borislav Petkov wrote:
 > That's an interesting question but I think you're better fitted to
 > answer it - I try to avoid the APEI spec as much as possible.
 >
 > :-)
 >

Oh, I've hardly scratched the surface w.r.t APEI. I think I'll let the 
experts comment on this :)


Thanks,
Naveen

