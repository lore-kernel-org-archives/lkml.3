Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaJGK35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:29:57 -0400
Received: from zeus.imc.nl ([213.244.168.139]:30286 "EHLO zeus.imc.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbaJGK3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:29:55 -0400
X-Greylist: delayed 639 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2014 06:29:55 EDT
X-IronPort-AV: E=Sophos;i="5.04,669,1406584800"; 
   d="scan'208";a="17506791"
Message-ID: <5433BE1B.5020703@imc.nl>
Date: Tue, 7 Oct 2014 12:19:07 +0200
From: Adrian Vasile <adrian.vasile@imc.nl>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alex <xor@xor.bz>, <linux-kernel@vger.kernel.org>
Subject: Re: TSC Problems (warp between CPUs)
References: <b65bbca027bb2a473f989e60871c2dd2@xor.bz> <fcade74fbf715ff965b5a1d3b21e2c21@xor.bz> <20131228143547.38d0a0b9@alan.etchedpixels.co.uk> <e44ff95b0f7962a11cfcdb83da6c5595@xor.bz> <5d63695a1ad08aea5673a833e5055c6b@xor.bz>
In-Reply-To: <5d63695a1ad08aea5673a833e5055c6b@xor.bz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.130.146.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

Have you managed to fix this issue? I'm seeing the same on an Asus X99
Deluxe board with both 5930K and 5960X and the latest BIOS as of today
(0904).
I had some hopes of linux-3.17 working around this but it did not help.
Asus support is disappointing, I don't think they will ever fix this.

I'm wondering if it's worth trying a different motherboard, any
recommendations?

Thank you.

Regards,
Adrian

On 31/12/13 22:24, Alex wrote:
> A Happy new year to all :)
>
> Just wondering whether anyone has any ideas on how I could force the
> TSC to resync?
>
> Starting to get a bit desperate. The motherboard manufacturers support
> is useless.... They keep telling me to install Windows *groan*. I dont
> think there is any easy way to expose what clock source the OS is
> using even in windows.
>
> I even tried firing an email at the AmiBios guys. I think I have
> exhausted every avenue of help as far as the hardware goes.
>
> Any suggestions?
>
> Kind regards,
> Alex
>
> On 2013-12-29 11:21, Alex wrote:
>> On 2013-12-29 01:35, One Thousand Gnomes wrote:
>>>> not guaranteed to be precise. For example a SMI (System Management
>>>> Interrupt) could interrupt the software flow that is attempting to
>>>> write
>>>> the time-stamp counter immediately prior to the WRMSR. This could mean
>>>> the value written to the TSC could vary by thousands to millions of
>>>> clocks.
>>>
>>> Yes SMI is a disaster area for any real time activity (and many other
>>> things ;) ), but many systems actually make little use of it,
>>> especially
>>> once the USB is owned by the OS.
>>>
>>> For synchronization you can retry the sync if it isn't within an
>>> acceptable range. The odds of getting an SMI mid sync setup should be
>>> very very low, so the odds of repeating the failure several times
>>> should
>>> be negligible and after a few tries you could give up and assume the
>>> hardware is buggered then fall back to HPET.
>>
>> Hi Alan,
>>
>> The sync retry sounds like an interesting strategy but is outside my
>> knowledge
>> scope as a regular end user (I do have a reasonable understanding of
>> C and can patch+
>> recompile) but I lack the architecture knowledge to implement a patch
>> to do this.
>>
>> Any suggestions?
>

________________________________

The information in this e-mail is intended only for the person or entity to which it is addressed.

It may contain confidential and /or privileged material. If someone other than the intended recipient should receive this e-mail, he / she shall not be entitled to read, disseminate, disclose or duplicate it.

If you receive this e-mail unintentionally, please inform us immediately by "reply" and then delete it from your system. Although this information has been compiled with great care, neither IMC Financial Markets & Asset Management nor any of its related entities shall accept any responsibility for any errors, omissions or other inaccuracies in this information or for the consequences thereof, nor shall it be bound in any way by the contents of this e-mail or its attachments. In the event of incomplete or incorrect transmission, please return the e-mail to the sender and permanently delete this message and any attachments.

Messages and attachments are scanned for all known viruses. Always scan attachments before opening them.
