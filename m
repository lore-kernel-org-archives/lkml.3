Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064Ab3FMS0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:26:12 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:62484 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056Ab3FMS0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:26:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_LGv2ayCkO0rndkc5ahaW0S9ZH5SW5p=KcBL4o6TjFoZLmLQ@mail.gmail.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
	<CAN_LGv2ayCkO0rndkc5ahaW0S9ZH5SW5p=KcBL4o6TjFoZLmLQ@mail.gmail.com>
Date: Fri, 14 Jun 2013 00:26:07 +0600
Message-ID: <CAN_LGv25Z13QuXvB5EhLVm0jDG9pKCZ-di747-uhp81wZUpbPw@mail.gmail.com>
Subject: Re: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/13 Alexander E. Patrakov <patrakov@gmail.com>:
> 2013/6/13 Jiang Liu <jiang.liu@huawei.com>:
>> Alexander E. Patrakov <patrakov@gmail.com> reports two bugs related to
>> dock station support on Sony VAIO VPCZ23A4R. Actually there are at least
>> four bugs related to Sony VAIO VPCZ23A4R dock support.
>> 1) can't correctly detect hotplug slot for dock state
>> 2) resource leak on undocking
>> 3) resource allocation failure for dock devices
>> 4) one bug in intel_snd_hda driver
>>
>> The first patch fixes issue 1, and the second patch fixes issue 2.
>> These two patches, if accepted, should be material for stable branches
>> too.
>> Patch 3-9 are code improvement for ACPI and dock driver.
>>
>> I have found the root cause for issue three, but still working on
>> solutions, and seems can't be solve in short time. So please help
>> to review and test patches for issue 1) and 2) first.
>>
>> Hi Alexander, could you please help to test the whole patchset?
>
> Tested on top of 3.10-rc5, with no other patches applied.
> Unfortunately, lockdep complains on the second docking attempt in the
> initially-undocked case. Please see the attached dmesg output.
>
> I have not tested the initially-docked case yet, will do that in 10 minutes.

Tested. The device list is updated as expected if the radeon driver is
blacklisted and there are no open fds to the audio card.

If radeon is not blacklisted, I hit
https://bugzilla.kernel.org/show_bug.cgi?id=59681 , but it is not a
regression.

--
Alexander E. Patrakov
