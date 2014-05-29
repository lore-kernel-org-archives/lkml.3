Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaE2VYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:24:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbaE2VYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:24:17 -0400
Message-ID: <5387A57B.6050204@suse.de>
Date: Thu, 29 May 2014 23:24:11 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>,
        Kim Phillips <kim.phillips@linaro.org>
CC: a.motakis@virtualopensystems.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, jhovold@gmail.com, will.deacon@arm.com,
        a.rigo@virtualopensystems.com, rob.herring@calxeda.com,
        stuart.yoder@freescale.com, rob@landley.net, grant.likely@linaro.org,
        tech@virtualopensystems.com, clbchenlibo.chen@huawei.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        Julien Grall <julien.grall@linaro.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v5_v2 01/11] driver core: platform: add device binding
 path 'driver_override'
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>	 <1398700371-20096-2-git-send-email-a.motakis@virtualopensystems.com>	 <20140520192537.bab9fa2088c1cd5da3f92639@linaro.org> <1401392619.2412.102.camel@ul30vt.home>
In-Reply-To: <1401392619.2412.102.camel@ul30vt.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 29.05.14 21:43, Alex Williamson wrote:
> On Tue, 2014-05-20 at 19:25 -0500, Kim Phillips wrote:
>> From: Kim Phillips <kim.phillips@freescale.com>
>>
>> Needed by platform device drivers, such as the vfio-platform driver
>> later in series, in order to bypass the existing OF, ACPI, id_table and
>> name string matches, and successfully be able to be bound to any
>> device, like so:
>>
>> echo vfio-platform > /sys/bus/platform/devices/fff51000.ethernet/driver_override
>> echo fff51000.ethernet > /sys/bus/platform/devices/fff51000.ethernet/driver/unbind
>> echo fff51000.ethernet > /sys/bus/platform/drivers_probe
>>
>> This mimics "PCI: Introduce new device binding path using
>> pci_dev.driver_override" [1], which is an interface enhancement
>> for more deterministic PCI device binding, e.g., when in the
>> presence of hotplug.
>>
>> [1] https://lists.cs.columbia.edu/pipermail/kvmarm/2014-May/009527.html
>>
>> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Looks largely identical to the PCI version of the same that has been
> accepted for v3.16 and ack'd by GregKH.
>
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

Yup, would be great to have feature parity for device binding on 
platform and PCI.

Reviewed-by: Alexander Graf <agraf@suse.de>


Alex

