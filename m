Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaCMP20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:28:26 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47045 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaCMP2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:28:23 -0400
Message-ID: <5321CE94.5070506@kernel.dk>
Date: Thu, 13 Mar 2014 09:28:20 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, Mike Miller <mike.miller@hp.com>,
        iss_storagedev@hp.com, linux-pci@vger.kernel.org,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v2 0/2] block: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
References: <cover.1393404496.git.agordeev@redhat.com> <20140313041231.GC26657@google.com>
In-Reply-To: <20140313041231.GC26657@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 10:12 PM, Bjorn Helgaas wrote:
> On Wed, Feb 26, 2014 at 10:02:40AM +0100, Alexander Gordeev wrote:
>> Changes since v1:
>>    - cciss: patch #1: a weird 'goto' removed;
>>    - cciss: patch #2: pci_enable_msix_exact() used, not pci_enable_msix_range();
>>    - rsxx: patch dropped - no need to change anything;
>>
>> As result of deprecation of MSI-X/MSI enablement functions
>> pci_enable_msix() and pci_enable_msi_block() all drivers
>> using these two interfaces need to be updated to use the
>> new pci_enable_msi_range()  or pci_enable_msi_exact()
>> and pci_enable_msix_range() or pci_enable_msix_exact()
>> interfaces.
>>
>> This change updates 'cciss' only, but there is also 'nvme' update
>> pending - I am waiting for Intel guys to clarify if they want to
>> route it thru their tree. If not, I will post the 'nvme' patch as
>> a follow-up to this series.
>
> Hi Jens,
>
> I'd like to get these merged during the v3.15 merge window.  I'd be glad to
> review and apply them through my tree, unless you want to do it.  They do
> depend on f7fc32c, which went in after the v3.14 merge window, which makes
> it a bit of a hassle.

My 3.15/drivers (and core) branch are based off 3.14-rc3, so it should 
be OK. I've queued them up, as it's mostly a followup to the previous 
ones from Alexander.

-- 
Jens Axboe

