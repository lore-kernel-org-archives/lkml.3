Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629Ab3DDO53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:57:29 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39889 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762604Ab3DDO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:57:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130404145012.GA3403@neilslaptop.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com> <CAErSpo4=L9q+q5hqP2Avw6uceQwZiPuOzadhsqGpu6aP53PMbQ@mail.gmail.com>
 <1365085649.28127.66.camel@i7.infradead.org> <20130404145012.GA3403@neilslaptop.think-freely.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 4 Apr 2013 08:57:06 -0600
Message-ID: <CAErSpo6x5rokg8np7xEKO6y6Qke5X7=r7J7VB2LVrAGGzDC1sA@mail.gmail.com>
Subject: Re: [PATCH v2] irq: add quirk for broken interrupt remapping on 55XX chipsets
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 8:50 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Thu, Apr 04, 2013 at 03:27:29PM +0100, David Woodhouse wrote:
>> On Wed, 2013-04-03 at 17:53 -0600, Bjorn Helgaas wrote:
>> > );
>> > > +
>> > > +       if ((revision == 0x13) && irq_remapping_enabled) {
>> > > +                pr_warn(HW_ERR "This system BIOS has enabled interrupt remapping\n"
>> > > +                        "on a chipset that contains an errata making that\n"
>> > > +                        "feature unstable.  Please reboot with nointremap\n"
>> > > +                        "added to the kernel command line and contact\n"
>> > > +                        "your BIOS vendor for an update");
>>
>> This should be WARN_TAINT(TAINT_FIRMWARE_WORKAROUND). And 'an erratum'.
>>
> Ok, copy that. I'll repost shortly

When you do, please include URLs for any problem reports or bugzillas you have.

I assume Windows "just works" in this situation?
