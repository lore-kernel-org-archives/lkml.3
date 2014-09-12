Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaILDNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:13:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51022 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaILDNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:13:47 -0400
Message-ID: <541264DB.8050702@oracle.com>
Date: Fri, 12 Sep 2014 11:13:31 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: avanzini.arianna@gmail.com
CC: David Vrabel <david.vrabel@citrix.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, felipe.franciosi@citrix.com,
        axboe@fb.com
Subject: Re: [PATCH RFC 4/4] xen, blkback: add support for multiple block
 rings
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com> <1408706404-6614-5-git-send-email-avanzini.arianna@gmail.com> <53F7428E.90806@citrix.com> <20140911234530.GB2052@gmail.com>
In-Reply-To: <20140911234530.GB2052@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/12/2014 07:45 AM, Arianna Avanzini wrote:
> On Fri, Aug 22, 2014 at 02:15:58PM +0100, David Vrabel wrote:
>> On 22/08/14 12:20, Arianna Avanzini wrote:
>>> This commit adds to xen-blkback the support to retrieve the block
>>> layer API being used and the number of available hardware queues,
>>> in case the block layer is using the multi-queue API. This commit
>>> also lets the driver advertise the number of available hardware
>>> queues to the frontend via XenStore, therefore allowing for actual
>>> multiple I/O rings to be used.
>>
>> Does it make sense for number of queues should be dependent on the
>> number of queues available in the underlying block device?  
> 
> Thank you for raising that point. It probably is not the best solution.
> 
> Bob Liu suggested to have the number of I/O rings depend on the number
> of vCPUs in the driver domain. Konrad Wilk suggested to compute the
> number of I/O rings according to the following formula to preserve the
> possibility to explicitly define the number of hardware queues to be
> exposed to the frontend:
> what_backend_exposes = some_module_parameter ? :
>                    min(nr_online_cpus(), nr_hardware_queues()).
> io_rings = min(nr_online_cpus(), what_backend_exposes);
> 
> (Please do correct me if I misunderstood your point)

Since xen-netfront/xen-netback driver have already implemented
multi-queue, I'd like we can use the same way as the net driver
negotiate of number of queues.

Thanks,
-Bob
