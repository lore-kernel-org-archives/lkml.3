Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaETMKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:10:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:16977 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaETMKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:10:20 -0400
X-IronPort-AV: E=Sophos;i="4.98,874,1392163200"; 
   d="scan'208";a="132872357"
Message-ID: <537B4628.7020008@citrix.com>
Date: Tue, 20 May 2014 13:10:16 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <eshelton@pobox.com>, <hpa@zytor.com>,
        <ian.campbell@citrix.com>, <jbeulich@suse.com>, <jeremy@goop.org>,
        <konrad.wilk@oracle.com>, <matt.fleming@intel.com>, <mingo@redhat.com>,
        <mjg59@srcf.ucam.org>, <stefano.stabellini@eu.citrix.com>,
        <tglx@linutronix.de>
Subject: Re: [PATCH v4 3/5] xen: Put EFI machinery in place
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com> <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com> <537B2494.2080702@citrix.com> <20140520112933.GF3529@olila.local.net-space.pl>
In-Reply-To: <20140520112933.GF3529@olila.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/14 12:29, Daniel Kiper wrote:
> 
>>> +	if (!xen_initial_domain() || HYPERVISOR_dom0_op(&op))
>>> +		return NULL;
>>
>> 	if (!xen_initial_domain())
>> 		return NULL;
>>
>> 	if (HYPERVISOR_dom0_op(&op) < 0)
>> 		return NULL;
> 
> What is wrong with my if?

Style.  The function returns -ve on error not a boolean success/fail.

>>> +
>>> +	/* Here we know that Xen runs on EFI platform. */
>>> +
>>> +	efi = efi_xen;
>>> +
>>> +	op.cmd = XENPF_firmware_info;
>>> +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
>>> +	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
>>> +	info->vendor.bufsz = sizeof(vendor);
>>> +	set_xen_guest_handle(info->vendor.name, vendor);
>>> +
>>> +	if (!HYPERVISOR_dom0_op(&op)) {
>>
>> if (HYPERVISOR_dom0_op(&op) == 0)
> 
> Ditto?

Again, style.

David
