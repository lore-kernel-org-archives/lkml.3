Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3IWODt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:03:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28520 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3IWODr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:03:47 -0400
Message-ID: <52404ABD.1020801@oracle.com>
Date: Mon, 23 Sep 2013 10:05:49 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xen.org, david.vrabel@citrix.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/5] xen/PMU: Sysfs interface for setting Xen PMU mode
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com> <1378827110-4192-3-git-send-email-boris.ostrovsky@oracle.com> <20130923131743.GC3175@phenom.dumpdata.com>
In-Reply-To: <20130923131743.GC3175@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 09:17 AM, Konrad Rzeszutek Wilk wrote:
> On Tue, Sep 10, 2013 at 11:31:47AM -0400, Boris Ostrovsky wrote:
>> +
>> +/* Parameter structure for HYPERVISOR_xenpmu_op call */
>> +struct xenpmu_params {
>> +	union {
>> +		struct version {
>> +			uint8_t maj;
>> +			uint8_t min;
>> +		} version;
>> +		uint64_t pad;
>> +	};
>> +	uint64_t control;
>> +};
>> +
>> +/* VPMU modes */
>> +#define VPMU_MODE_MASK     0xff
>> +#define VPMU_OFF           0
>> +/* guests can profile themselves, (dom0 profiles itself and Xen) */
>> +#define VPMU_ON            (1<<0)
>> +/*
>> + * Only dom0 has access to VPMU and it profiles everyone: itself,
>> + * the hypervisor and the guests.
>> + */
>> +#define VPMU_PRIV          (1<<1)
>> +
>> +/* VPMU flags */
>> +#define VPMU_FLAGS_MASK    ((uint32_t)(~VPMU_MODE_MASK))
>> +#define VPMU_INTEL_BTS     (1<<8) /* Ignored on AMD */
>> +
>> +#endif /* __XEN_PUBLIC_XENPMU_H__ */
> Looks OK to me if there are no changes to the hypervisor ABI.


v2 patches for hypervisor have different layout for shared structures 
and parameters so this will have to change as well. I don't believe 
there are any logic changes to this series due to this v2, except for 
the first patch (getting Xen symbols into dom0).

-boris
