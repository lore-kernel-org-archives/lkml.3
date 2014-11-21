Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaKUTe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:34:59 -0500
Received: from mail-bl2on0102.outbound.protection.outlook.com ([65.55.169.102]:63360
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751137AbaKUTe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:34:57 -0500
X-WSS-ID: 0NFEME3-08-8KK-02
X-M-MSG: 
Message-ID: <546F93D5.8030704@amd.com>
Date: Fri, 21 Nov 2014 21:34:45 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        John Bridgman <John.Bridgman@amd.com>, Ben Goz <ben.goz@amd.com>,
        Jay Cornwall <jay.cornwall@amd.com>,
        "Evgeny Pinchuk" <evgeny.pinchuk@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>
Subject: Re: [PATCH v5 08/24] amdkfd: Add amdkfd skeleton driver
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
	 <1415471865-1893-9-git-send-email-oded.gabbay@amd.com>
 <1416565445.6958.3.camel@x220>
In-Reply-To: <1416565445.6958.3.camel@x220>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377424004)(199003)(24454002)(51704005)(189002)(377454003)(479174003)(50466002)(33656002)(102836001)(36756003)(65956001)(62966003)(77156002)(20776003)(23676002)(64706001)(47776003)(59896002)(50986999)(54356999)(87266999)(76176999)(65816999)(21056001)(87936001)(106466001)(99396003)(68736004)(110136001)(83506001)(31966008)(80316001)(44976005)(97736003)(19580405001)(19580395003)(95666004)(92726001)(84676001)(4396001)(92566001)(101416001)(120916001)(105586002)(86362001)(107046002)(46102003)(64126003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 0402872DA1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/21/2014 12:24 PM, Paul Bolle wrote:
> On Sat, 2014-11-08 at 20:37 +0200, Oded Gabbay wrote:
>> This patch adds the amdkfd skeleton driver. The driver does nothing except
>> define a /dev/kfd device.
>>
>> It returns -ENODEV on all amdkfd IOCTLs.
>>
>> v3: Move bool field to the end of structure, removed the pmc ioctls and added
>> a meaningful error message for ioctl error.
>>
>> v5:
>>
>> Create a new folder drm/amd and move amdkfd from drm/radeon/ to drm/amd/
>> Remove scheduler_class from kfd_priv.h as it was never used
>> Add skeleton implementation of the Get Version IOCTL
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> 
> It seems v6 of this patch is included in today's linux-next (ie,
> next-20141121).
> 
>>  drivers/gpu/drm/Kconfig                  |   2 +
>>  drivers/gpu/drm/Makefile                 |   1 +
>>  drivers/gpu/drm/amd/amdkfd/Kconfig       |  10 ++
>>  drivers/gpu/drm/amd/amdkfd/Makefile      |   9 ++
>>  drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 210 +++++++++++++++++++++++++++++++
>>  drivers/gpu/drm/amd/amdkfd/kfd_device.c  | 130 +++++++++++++++++++
>>  drivers/gpu/drm/amd/amdkfd/kfd_module.c  | 101 +++++++++++++++
>>  drivers/gpu/drm/amd/amdkfd/kfd_priv.h    |  81 ++++++++++++
>>  8 files changed, 544 insertions(+)
>> [...]
>> diff --git a/drivers/gpu/drm/amd/amdkfd/Kconfig b/drivers/gpu/drm/amd/amdkfd/Kconfig
>> new file mode 100644
>> index 0000000..a2ae6d4
>> --- /dev/null
>> +++ b/drivers/gpu/drm/amd/amdkfd/Kconfig
>> @@ -0,0 +1,10 @@
>> +#
>> +# Heterogenous system architecture configuration
>> +#
>> +
>> +config HSA_AMD
>> +	tristate "HSA kernel driver for AMD GPU devices"
>> +	depends on (DRM_RADEON || DRM_AMDGPU) && AMD_IOMMU_V2 && X86_64
> 
> There's currently no Kconfig symbol DRM_AMDGPU (nor anything similar).
> Will that symbol be added in a future patch?
> 
The DRM_AMDGPU symbol belongs to AMD's new Linux kernel graphic driver, called
amdgpu. That driver is not yet upstreamed, so its symbol is not present in any
Kconfig file. However, internally we work with that driver so that's why it
appears in my patch.

I can remove it if it violates some rule. I have no problem adding it back once
amdgpu is upstreamed.

	Oded

>> +	default m
>> +	help
>> +	  Enable this if you want to use HSA features on AMD GPU devices.
> 
> 
> Paul Bolle
> 
