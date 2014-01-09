Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaAITHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:07:38 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34466 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082AbaAITHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:07:36 -0500
Message-ID: <52CEF37B.9010401@arm.com>
Date: Thu, 09 Jan 2014 19:07:39 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sudeep.Holla@arm.com, "x86@kernel.org" <x86@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH RFC 1/3] drivers: base: support cpu cache information
 interface to userspace via sysfs
References: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com> <1389209168-17189-2-git-send-email-sudeep.holla@arm.com> <20140108202613.GD8417@kroah.com>
In-Reply-To: <20140108202613.GD8417@kroah.com>
X-OriginalArrivalTime: 09 Jan 2014 19:07:31.0778 (UTC) FILETIME=[0C1C5220:01CF0D6E]
X-MC-Unique: 114010919073400301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 20:26, Greg Kroah-Hartman wrote:
> On Wed, Jan 08, 2014 at 07:26:06PM +0000, Sudeep Holla wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>>
>> This patch adds initial support for providing processor cache information
>> to userspace through sysfs interface. This is based on x86 implementation
>> and hence the interface is intended to be fully compatible.
>>
>> A per-cpu array of cache information maintained is used mainly for
>> sysfs-related book keeping.
>>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> ---
>>  drivers/base/Makefile     |   2 +-
>>  drivers/base/cacheinfo.c  | 296 ++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/cacheinfo.h |  43 +++++++
>>  3 files changed, 340 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/base/cacheinfo.c
>>  create mode 100644 include/linux/cacheinfo.h
> 
> You are creating sysfs files, yet you didn't add Documentation/ABI/
> information, which is required.  Please fix that.
> 
Ah, I overlooked it. But I am not creating any new sysfs files in this series.
I am just trying to unify duplicated code in various architectures.

Since these sysfs files are already created in:
1. arch/ia64/kernel/topology.c
2. arch/powerpc/kernel/cacheinfo.c
3. arch/s390/kernel/cache.c
4. arch/x86/kernel/cpu/intel_cacheinfo.c and
also already used by user-space tools like `lscpu` I assumed it's already
documented.

I will add it in next version.

Regards,
Sudeep

