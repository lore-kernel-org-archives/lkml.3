Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262Ab3DPIRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:17:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:31105 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932781Ab3DPIRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:17:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,484,1363158000"; 
   d="scan'208";a="318915516"
From: "Wang, Rui Y" <rui.y.wang@intel.com>
To: "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "linuxram@us.ibm.com" <linuxram@us.ibm.com>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>
Subject: RE: [Bug fix PATCH] resource: Reusing a resource structure
 allocated by bootmem
Thread-Topic: [Bug fix PATCH] resource: Reusing a resource structure
 allocated by bootmem
Thread-Index: AQHOOnXPXkyMPlWooEiAG677nG6jc5jYfnRQ
Date: Tue, 16 Apr 2013 08:17:11 +0000
Message-ID: <FC9702EC51E4CA40A875703BEBD6CEF89E5B64@SHSMSX101.ccr.corp.intel.com>
References: <516B62C0.70504@jp.fujitsu.com>
 <CANVTcTZoNVh7i=iEqAcqSNSZ9vtRVxRkV=sm73S3sEDEYAHRGQ@mail.gmail.com>
In-Reply-To: <CANVTcTZoNVh7i=iEqAcqSNSZ9vtRVxRkV=sm73S3sEDEYAHRGQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Date: Mon, 15 Apr 2013 11:15:28 +0900
> Subject: [Bug fix PATCH] resource: Reusing a resource structure allocated by
> bootmem
> To: akpm@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org, rientjes@google.com, linuxram@us.ibm.com,
> toshi.kani@hp.com, Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> <<...>>
> +	if (bootmem_resource.sibling) {
> +		spin_lock(&bootmem_resource_lock);
> +		res = bootmem_resource.sibling;
> +		bootmem_resource.sibling = res->sibling;
> +		spin_unlock(&bootmem_resource_lock);
> +		memset(res, 0, sizeof(struct resource));
> +	} else {
> +		res = kzalloc(sizeof(struct resource), flags);
> +	}

bootmem_resource_lock does not protect the if() statement from accessing bootmem_resource.sibling.

spin_lock(&bootmem_resource_lock);
if (bootmem_resource.sibling) {
...

Rui
