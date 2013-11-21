Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3KUCBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:01:48 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:50196 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3KUCBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:01:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4ReYw5koMrwcuNQj7yfFXvDnuZGiRc70mekv6L40KjWw@mail.gmail.com>
References: <1383749353-3510-1-git-send-email-ethan.kernel@gmail.com>
	<CAErSpo5bYwgK618AOgvD=mgbfjcLLGE3CVw1SN3sP3PqRaCk5A@mail.gmail.com>
	<CAErSpo4ReYw5koMrwcuNQj7yfFXvDnuZGiRc70mekv6L40KjWw@mail.gmail.com>
Date: Thu, 21 Nov 2013 10:01:44 +0800
Message-ID: <CABawtvNHbRKdCXcfa-fOcS-7kA1TqBey+h+8QFFUtfYWwVRW8w@mail.gmail.com>
Subject: Re: [PATCH] PCI: Init NumVFs register to zero in sriov_init()
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yu Zhao <yu.zhao@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,
    I revised the description part with the original bug material as
below, help to take a look, will send V2 back to home, SMTP blocked by
company network.

    PCI: Init NumVFs register to zero in sriov_init()

    Though no specification about NumVFs register initial value after
POST, to void the confusion
    lspci output as following before VF was enabled, we should clear
the NumVFs value left by BIOS
    to zero:

    #lspci -vvvxxx -s 13:00.0
   13:00.0 Ethernet controller: Intel Corporation 82599EB 10-Gigabit SFI/SFP+
    Network Connection (rev 01)  Subsystem: Oracle/SUN Ethernet Server
Adapter X520-2
    ~
    Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
            IOVCap: Migration-, Interrupt Message Number: 000
            IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy+
            IOVSta: Migration-
            Initial VFs: 64, Total VFs: 64, Number of VFs: 64, Function
            Dependency Link: 00
                                                                     ^dazed !
    140: 03 00 01 15 c4 24 c8 ff ff 21 1b 00 00 00 00 00
    150: 0e 00 01 16 00 01 00 00 00 00 00 00 00 00 00 00
    160: 10 00 01 00 00 00 00 00 10 00 00 00 40 00 40 00

          ^        ^Total VFs

          Initial VFs
    170: 40 00 00 00 80 00 02 00 00 00 ed 10 53 05 00 00
             ^Number of VFs


Thanks,
Ethan


On Wed, Nov 20, 2013 at 8:07 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Nov 19, 2013 at 3:24 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> [+cc linux-pci]
>>
>> On Wed, Nov 6, 2013 at 7:49 AM, ethan.zhao <ethan.kernel@gmail.com> wrote:
>>> Though no specification about NumVFs register initial value after POST, to void the confusion
>>> lspci output as following before VF was enabled, we should clear the NumVFs value left by BIOS
>>> to zero:
>>>
>>> $lspci -vvv -s 03:00.0
>>> Ethernet controller: Intel Corporation 82599EB 10-Gigabit SFI/SFP+ Network Connection (rev 01)
>>> ~
>>> Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
>>>                 IOVCap: Migration-, Interrupt Message Number: 000
>>>                 IOVCtl: Enable+ Migration- Interrupt- MSE+ ARIHierarchy+
>>>                 IOVSta: Migration-
>>>                 Initial VFs: 64, Total VFs: 64, Number of VFs: 64, Function Dependency Link: 00
>>>                                                               ^dazed !
>
> Did you mean to show lspci output from before SR-IOV was enabled?  It
> looks like SR-IOV is enabled here, so I don't think your patch would
> change this output at all.
>
> Bjorn
