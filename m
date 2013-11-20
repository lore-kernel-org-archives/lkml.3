Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3KTAH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:07:57 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54257 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3KTAHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:07:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5bYwgK618AOgvD=mgbfjcLLGE3CVw1SN3sP3PqRaCk5A@mail.gmail.com>
References: <1383749353-3510-1-git-send-email-ethan.kernel@gmail.com> <CAErSpo5bYwgK618AOgvD=mgbfjcLLGE3CVw1SN3sP3PqRaCk5A@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 19 Nov 2013 17:07:35 -0700
Message-ID: <CAErSpo4ReYw5koMrwcuNQj7yfFXvDnuZGiRc70mekv6L40KjWw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Init NumVFs register to zero in sriov_init()
To: "ethan.zhao" <ethan.kernel@gmail.com>
Cc: Yu Zhao <yu.zhao@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 3:24 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc linux-pci]
>
> On Wed, Nov 6, 2013 at 7:49 AM, ethan.zhao <ethan.kernel@gmail.com> wrote:
>> Though no specification about NumVFs register initial value after POST, to void the confusion
>> lspci output as following before VF was enabled, we should clear the NumVFs value left by BIOS
>> to zero:
>>
>> $lspci -vvv -s 03:00.0
>> Ethernet controller: Intel Corporation 82599EB 10-Gigabit SFI/SFP+ Network Connection (rev 01)
>> ~
>> Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
>>                 IOVCap: Migration-, Interrupt Message Number: 000
>>                 IOVCtl: Enable+ Migration- Interrupt- MSE+ ARIHierarchy+
>>                 IOVSta: Migration-
>>                 Initial VFs: 64, Total VFs: 64, Number of VFs: 64, Function Dependency Link: 00
>>                                                               ^dazed !

Did you mean to show lspci output from before SR-IOV was enabled?  It
looks like SR-IOV is enabled here, so I don't think your patch would
change this output at all.

Bjorn
