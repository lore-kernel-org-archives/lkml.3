Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3JBSAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:00:54 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:53319 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3JBSAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:00:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j=Huz8d+00vMJa8mCFCKWeNG9-XAc1u19v89fNruM9kg@mail.gmail.com>
References: <cover.1380703262.git.agordeev@redhat.com>
	<63caad476ca6b7f3481d5512febcb4ef3db72209.1380703263.git.agordeev@redhat.com>
	<CAPcyv4j=Huz8d+00vMJa8mCFCKWeNG9-XAc1u19v89fNruM9kg@mail.gmail.com>
Date: Wed, 2 Oct 2013 11:00:51 -0700
Message-ID: <CAPcyv4gB7R2_zn=Wvowtxcn4muWNd6aK6rsURss3rnhj0VAyfA@mail.gmail.com>
Subject: Re: [PATCH RFC 34/77] ioat: Update MSI/MSI-X interrupts enablement code
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jon Mason <jon.mason@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 10:31 AM, Williams, Dan J
<dan.j.williams@intel.com> wrote:
> [ dropping all cc's except lkml ]
>
> On Wed, Oct 2, 2013 at 3:48 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
>> As result of recent re-design of the MSI/MSI-X interrupts enabling
>> pattern this driver has to be updated to use the new technique to
>> obtain a optimal number of MSI/MSI-X interrupts required.
>>
>
> What happens if this patch is not applied.  This changelog does not
> have enough information for me to judge the patch.  Unless I missed it
> I do not see a patch 00/77 explaining the background of the change,
> and a quick search did not turn up a discussion of why drivers now
> need to call pci_msix_table_size() prior to pci_enable_msix.

I see patch 00/77 now and I still don't see the need for ioatdma to be
updated.  If we fail the subsequent request_irq, the driver will still
fall back to trying less interrupts.
