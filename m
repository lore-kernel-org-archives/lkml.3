Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935624Ab3DJCYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 22:24:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22920 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762266Ab3DJCYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 22:24:43 -0400
Message-ID: <5164CD81.3080403@oracle.com>
Date: Wed, 10 Apr 2013 10:25:05 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xensource.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Feng Jin <joe.jin@oracle.com>, ben@guthro.net
Subject: Re: [PATCH] xen: minor fix in apic ipi interface func
References: <5163F29D.6080605@oracle.com> <20130409192054.GA1768@phenom.dumpdata.com>
In-Reply-To: <20130409192054.GA1768@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-04-10 03:20, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 09, 2013 at 06:51:09PM +0800, Zhenzhong Duan wrote:
>> xen_send_IPI_mask_allbutself uses native vector as input other than xen_vector.
> Ouch. But it looks as the only user of the .send_IPI_mask_allbutself
> is just xen_send_IPI_allbutself? Or is there another user of this?
It looks __default_local_send_IPI_allbutself called 
apic->send_IPI_mask_allbutself.

In set_xen_basic_apic_ops, apic->send_IPI_mask_allbutself = 
xen_send_IPI_mask_allbutself.
apic->send_IPI_mask_allbutself use native vector as input like other funcs.

> Is there a particular bug that was found with this?
No, just looking at code and see the error.

zduan
