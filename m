Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaEGROg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:14:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51372 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaEGROf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:14:35 -0400
Message-ID: <536A69E8.6070707@zytor.com>
Date: Wed, 07 May 2014 10:14:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "David E. Box" <david.e.box@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v3] x86/iosf: Make IOSF driver modular and usable by more
 drivers
References: <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>	<1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>	<20140507174801.20fc0d67@alan.etchedpixels.co.uk>	<536A67B8.1080805@zytor.com> <20140507181042.7b4dff18@alan.etchedpixels.co.uk>
In-Reply-To: <20140507181042.7b4dff18@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 10:10 AM, One Thousand Gnomes wrote:
> On Wed, 07 May 2014 10:04:56 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> On 05/07/2014 09:48 AM, One Thousand Gnomes wrote:
>>> On Fri,  2 May 2014 10:36:39 -0700
>>>> +bool iosf_mbi_available(void)
>>>> +{
>>>> +	return mbi_pdev;
>>>> +}
>>>> +EXPORT_SYMBOL(iosf_mbi_available);
>>>
>>> Probably worth a follow up patch that comments this so the assumption
>>> that iosf can never be unloaded or hot-unplugged is clear.
>>>
>>
>> When you say unloaded you mean the module or the hardware?
> 
> Both. Currently the hardware isn't removable (but could be virtually
> removed by playing with unplugging) and the module can't be unloaded so
> the assumption is fine.
> 

I guess I don't see why the module isn't removable.  Of course, any
driver which calls iosf_mbi_available() will depend on it, preventing
removal until *those* modules have been removed...

	-hpa


