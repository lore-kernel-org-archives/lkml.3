Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab3DQADb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:03:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52726 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3DQAD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:03:29 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <516DE6AC.3000602@jp.fujitsu.com>
Date: Wed, 17 Apr 2013 09:02:52 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Wang, Rui Y" <rui.y.wang@intel.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "linuxram@us.ibm.com" <linuxram@us.ibm.com>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>
Subject: Re: [Bug fix PATCH] resource: Reusing a resource structure allocated
 by bootmem
References: <516B62C0.70504@jp.fujitsu.com> <CANVTcTZoNVh7i=iEqAcqSNSZ9vtRVxRkV=sm73S3sEDEYAHRGQ@mail.gmail.com> <FC9702EC51E4CA40A875703BEBD6CEF89E5B64@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <FC9702EC51E4CA40A875703BEBD6CEF89E5B64@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

Thank you for your review.

2013/04/16 17:17, Wang, Rui Y wrote:
>> -----Original Message-----
>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Date: Mon, 15 Apr 2013 11:15:28 +0900
>> Subject: [Bug fix PATCH] resource: Reusing a resource structure allocated by
>> bootmem
>> To: akpm@linux-foundation.org
>> Cc: linux-kernel@vger.kernel.org, rientjes@google.com, linuxram@us.ibm.com,
>> toshi.kani@hp.com, Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> <<...>>
>> +	if (bootmem_resource.sibling) {
>> +		spin_lock(&bootmem_resource_lock);
>> +		res = bootmem_resource.sibling;
>> +		bootmem_resource.sibling = res->sibling;
>> +		spin_unlock(&bootmem_resource_lock);
>> +		memset(res, 0, sizeof(struct resource));
>> +	} else {
>> +		res = kzalloc(sizeof(struct resource), flags);
>> +	}
>

> bootmem_resource_lock does not protect the if() statement from accessing bootmem_resource.sibling.
>
> spin_lock(&bootmem_resource_lock);
> if (bootmem_resource.sibling) {

You are right. I'll update it.

Thanks,
Yasuaki Ishimatsu

> ...
>
> Rui
>


