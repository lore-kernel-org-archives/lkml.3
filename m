Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaACL1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:27:51 -0500
Received: from smtp.citrix.com ([66.165.176.89]:36358 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaACL1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:27:50 -0500
X-IronPort-AV: E=Sophos;i="4.95,597,1384300800"; 
   d="scan'208";a="89502286"
Message-ID: <52C69EB3.3030300@citrix.com>
Date: Fri, 3 Jan 2014 11:27:47 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 08/18] xen/pvh: Load GDT/GS in early PV bootup code
 for BSP.
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-9-git-send-email-konrad.wilk@oracle.com> <52C54E00.7010508@citrix.com> <20140102182413.GB3021@pegasus.dumpdata.com>
In-Reply-To: <20140102182413.GB3021@pegasus.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/14 18:24, Konrad Rzeszutek Wilk wrote:
>>> +		loadsegment(es, 0);
>>> +		loadsegment(ds, 0);
>>> +		loadsegment(fs, 0);
>>> +#else
>>> +		/* PVH: TODO Implement. */
>>> +		BUG();
>>> +#endif
>>> +		return;    <==============
>>> +	}
>>>  	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry_boot;
>>>  	pv_cpu_ops.load_gdt = xen_load_gdt_boot;
>>
>> If PVH uses native GDT why are these (and possibly other?) GDT ops needed?
> 
> They aren't. There is a 'return' there. I marked it for you with
> '<======'.

I missed that, in which case.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
