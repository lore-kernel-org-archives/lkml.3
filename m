Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbaDXOSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:18:42 -0400
Received: from si-002-i163.relay.mailchannels.net ([108.178.49.175]:49860 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756643AbaDXOSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:18:40 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 10:18:39 EDT
X-Sender-Id: totalchoicehosting|x-authuser|oren%2bscalemp.com
X-Sender-Id: totalchoicehosting|x-authuser|oren%2bscalemp.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Coren%252bscalemp.com
X-MailChannels-Auth-Id: totalchoicehosting
Message-ID: <53591B06.70305@scalemp.com>
Date: Thu, 24 Apr 2014 17:09:10 +0300
From: Oren Twaig <oren@scalemp.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH] X86: Hook apic vector allocation domain only when interrupt
 routing are set to ignore
References: <5357D07C.5080407@scalemp.com> <20140424062217.GA1104@gmail.com>
In-Reply-To: <20140424062217.GA1104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AuthUser: oren+scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 04/24/2014 09:22 AM, Ingo Molnar wrote:
>
> * Oren Twaig <oren@scalemp.com> wrote:
>
>> Set all inclusive vector allocation domain only if interrupt routing
>> is set to ignore. When in comply mode, vector allocation behavior
>> isn't changed.
>
> This changelog is too terse:
>
> Please update the changelog to describe the current behavior, and how
> it affects your platform. (I.e. how do users notice, if at all?)
>
> Then describe why you think that behavior should be changed. ie:
> what's the reason for this patch.
>
> Only then describe the details of the change itself.

I will send v2 of the patch with a revised and more detailed
explanation about the behavior aspect of the patch.

>
>> -    apic->vector_allocation_domain = fill_vector_allocation_domain;
>> +
>> +    if (!irc)
>> +        apic->vector_allocation_domain = fill_vector_allocation_domain;
>
> Please also run scripts/checkpatch.pl over your patch which will
> report trivial coding style problems like the one here.

Yep - did that just like the instructions on "SubmmitingPatches", unfortunately, although I've followed the Thunderbird configuration instructions
with external editor, it seems to sent the the email content wrong (bad line endings as I saw now).

So sorry for the trouble, will change to a text email client and will
resend the patch.

Thanks,
Oren.
>
> Thanks,
>
>     Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


