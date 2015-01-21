Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbbAUGNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:13:30 -0500
Received: from edison.jonmasters.org ([173.255.233.168]:41204 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbbAUGN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:13:26 -0500
X-Greylist: delayed 1450 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2015 01:13:26 EST
Message-ID: <54BF3DCA.4070708@jonmasters.org>
Date: Wed, 21 Jan 2015 00:48:58 -0500
From: Jon Masters <jonathan@jonmasters.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Laszlo Ersek <lersek@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        Borislav Petkov <bp@alien8.de>
CC: Dave Young <dyoung@redhat.com>, linux-efi <linux-efi@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
References: <20141209095843.GA3990@pd.tnic> <20141210021741.GA3280@darkstar.nay.redhat.com> <20141210104627.GA17053@pd.tnic> <20150105140332.GB3163@console-pimps.org> <54AAA723.1070605@redhat.com>
In-Reply-To: <54AAA723.1070605@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: Shorten efi regions output
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/5/15, 10:00 AM, Laszlo Ersek wrote:
> On 01/05/15 15:03, Matt Fleming wrote:
>> On Wed, 10 Dec, at 11:46:28AM, Borislav Petkov wrote:
>>> On Wed, Dec 10, 2014 at 10:17:41AM +0800, Dave Young wrote:
>>>> I have same feeling with you, it is too long for most of people.
>>>>
>>>> Since the printk code are for EFI_DEBUG, they are around the #ifdef
>>>> so I would like to see a kernel param like efi_debug=on, so only
>>>> efi_debug is specified then these verbose messages are printed.
>>>> Without the param kernel can print some basic infomation about the
>>>> memory ranges.
>>>>
>>>> In arm64 code there's already a uefi_debug param it can be moved to
>>>> general code so that there will be a goable switch.
>>>
>>> Hmm, makes sense to me. Maybe we should really hide those behind a
>>> debug switch, the question is whether asking the user to boot with
>>> "efi_debug=on" in order to see the regions is ok. And I think it is ok
>>> because we do that when debugging other stuff so I don't see anything
>>> different here.
>>>
>>> And then when they're disabled by default, we don't really need to
>>> shorten them as they're pure debug output then.
>>>
>>> Matt?
>>
>> I'm fine with disabling the EFI memory output regions by default.
>>
>> Printing the regions is still useful for debugging, but like you
>> mention, we frequently ask users to enable other debug options when
>> tracking down issues.
>>
>> Laszlo, would you be OK with that?
>
> Sure.

Pardon my intrusion into this thread (just going over the past month's 
LKML for things I missed). I'd like to see some map output by default in 
the kernel. We have on a number of occasions found just this output 
useful in debugging boot issues on ARM servers and I suspect that will 
remain the case over the coming months. Sure, you can always tell 
someone to reboot, but then you have to rely on them doing it.

Jon.

