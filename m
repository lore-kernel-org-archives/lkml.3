Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3JVCnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 22:43:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39613 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3JVCnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 22:43:20 -0400
MIME-Version: 1.0
In-Reply-To: <5265395C.2040807@redhat.com>
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>
	<1382304926-1641-3-git-send-email-prarit@redhat.com>
	<CACVXFVMjEnkk8zYycsk6t4WiWOJ_NT1AKFoK7p5mQnFkw9KE-g@mail.gmail.com>
	<52651D8C.3090203@redhat.com>
	<CACVXFVOqM6BLv914G-PHyYXZR4-wqgosdLUiF=KuESx2+8UQ2A@mail.gmail.com>
	<5265395C.2040807@redhat.com>
Date: Tue, 22 Oct 2013 10:43:18 +0800
Message-ID: <CACVXFVP+RdNp_tkdfEBicE1S-92mwrS2w24pZ9pYu-5tR9ghTA@mail.gmail.com>
Subject: Re: [PATCH 2/2] intel_microcode, Fix long microcode load time when
 firmware file is missing
From: Ming Lei <ming.lei@canonical.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        tigran@aivazian.fsnet.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 10:25 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>
>
> On 10/21/2013 08:32 AM, Ming Lei wrote:
>> On Mon, Oct 21, 2013 at 8:26 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>>>>
>>>> And why don't you pass FW_ACTION_HOTPLUG? and you are sure
>>>> that udev isn't required to handle your microcode update request?
>>>>
>>>
>>> AFAICT in both cases, udev wasn't required to handle the cpu microcode update.
>>> Both drivers use CMH to load the firmware which removes the need for udev to do
>>> anything.  Admittedly maybe I've missed some odd use case but I don't think it
>>> is necessary.
>>
>> OK, so I guess the CMH still need uevent to get notified, right?
>
> The code as it is _currently_ written does not use uevents to load the processor
> firmware.  ie) call_usermodehelper does not need uevent to get notified, so I
> think FW_ACTION_NOHOTPLUG is correct.

You need to make sure your patch won't break userspace in old
distribution with your _currently_ code.

Actually if udev isn't used in your user space, the timeout issue
won't be triggered because it is blocked by udev.

Thanks,
--
Ming Lei
