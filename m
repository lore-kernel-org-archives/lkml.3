Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaACLyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:54:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:47009 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaACLyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:54:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,597,1384300800"; 
   d="scan'208";a="87319040"
Message-ID: <52C6A4E5.3080904@citrix.com>
Date: Fri, 3 Jan 2014 11:54:13 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 15/18] xen/pvh: Piggyback on PVHVM for grant driver
 (v2)
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-16-git-send-email-konrad.wilk@oracle.com> <52C59483.5030607@citrix.com> <20140102185023.GG3021@pegasus.dumpdata.com>
In-Reply-To: <20140102185023.GG3021@pegasus.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/14 18:50, Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 02, 2014 at 04:32:03PM +0000, David Vrabel wrote:
>> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
>>> @@ -1320,4 +1323,4 @@ static int __gnttab_init(void)
>>>  	return gnttab_init();
>>>  }
>>>  
>>> -core_initcall(__gnttab_init);
>>> +core_initcall_sync(__gnttab_init);
>>
>> Why has this become _sync?
> 
> It needs to run _after_ the xen_pvh_gnttab_setup has run (which is
> at gnttab_init):


The use of core_initcall_sync() doesn't imply any ordering to me.  Can't
you call xen_pvh_gnttab_setup() from within __gnttab_init() ?

David
