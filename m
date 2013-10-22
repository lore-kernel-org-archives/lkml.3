Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3JVXQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 19:16:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab3JVXQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 19:16:31 -0400
Message-ID: <52670744.3040103@redhat.com>
Date: Tue, 22 Oct 2013 19:16:20 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 2/2] intel_microcode, Fix long microcode load time when
 firmware file is missing
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>	<1382304926-1641-3-git-send-email-prarit@redhat.com>	<CACVXFVMjEnkk8zYycsk6t4WiWOJ_NT1AKFoK7p5mQnFkw9KE-g@mail.gmail.com>	<52651D8C.3090203@redhat.com>	<CACVXFVOqM6BLv914G-PHyYXZR4-wqgosdLUiF=KuESx2+8UQ2A@mail.gmail.com>	<5265395C.2040807@redhat.com> <CACVXFVP+RdNp_tkdfEBicE1S-92mwrS2w24pZ9pYu-5tR9ghTA@mail.gmail.com>
In-Reply-To: <CACVXFVP+RdNp_tkdfEBicE1S-92mwrS2w24pZ9pYu-5tR9ghTA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/21/2013 10:43 PM, Ming Lei wrote:
> On Mon, Oct 21, 2013 at 10:25 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>>
>>
>> On 10/21/2013 08:32 AM, Ming Lei wrote:
>>> On Mon, Oct 21, 2013 at 8:26 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>>>>>
>>>>> And why don't you pass FW_ACTION_HOTPLUG? and you are sure
>>>>> that udev isn't required to handle your microcode update request?
>>>>>
>>>>
>>>> AFAICT in both cases, udev wasn't required to handle the cpu microcode update.
>>>> Both drivers use CMH to load the firmware which removes the need for udev to do
>>>> anything.  Admittedly maybe I've missed some odd use case but I don't think it
>>>> is necessary.
>>>
>>> OK, so I guess the CMH still need uevent to get notified, right?
>>
>> The code as it is _currently_ written does not use uevents to load the processor
>> firmware.  ie) call_usermodehelper does not need uevent to get notified, so I
>> think FW_ACTION_NOHOTPLUG is correct.
> 
> You need to make sure your patch won't break userspace in old
> distribution with your _currently_ code.
> 

AFAICT, Suse, Ubuntu, Linux Mint and Fedora all work with my changes.

P.
