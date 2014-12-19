Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaLSPbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:31:41 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:49375 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaLSPbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:31:40 -0500
Date: Fri, 19 Dec 2014 16:31:35 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1931187914.20141219163135@eikelenboom.it>
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: konrad.wilk@oracle.com, David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: Bisected Linux regression: ACPI powerbutton events don't work under Xen since commit b81975eade8c6495f3c4d6746d22bdc95f617777
In-Reply-To: <54943C44.5080503@linux.intel.com>
References: <1824124380.20141219141645@eikelenboom.it> <54943C44.5080503@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Friday, December 19, 2014, 3:55:00 PM, you wrote:

> Hi Sander,
>         Could you please help to test attached patch? It works
> on native but I have no Xen environment at hand.
> Thanks!
> Gerry

Hi Gerry,

First of all thanks for the swift response !

Just tested this patch and i can report that it fixes my issue.

(i don't know if the xen-folks / Thomas have any comment on the way it is fixed.
But when this is final, it should probably be CC'd for -stable since it's broken
in both 3.17 and 3.18 afaik)

Thanks again,
--
Sander

> On 2014/12/19 21:16, Sander Eikelenboom wrote:
>> Hi,
>> 
>> When running under Xen, ACPI powerbutton events don't work anymore, 
>> there is no reaction when pressing the powerbutton.
>> 
>> On baremetal everything works fine, acpid gets the event and the 
>> machine powers down perfectly. The machine is an Intel NUC.
>>  
>> Bisection has lead to:
>> 
>> b81975eade8c6495f3c4d6746d22bdc95f617777 is the first bad commit
>> commit b81975eade8c6495f3c4d6746d22bdc95f617777
>> Author: Jiang Liu <jiang.liu@linux.intel.com>
>> Date:   Mon Jun 9 16:20:11 2014 +0800
>> 
>>     x86, irq: Clean up irqdomain transition code
>> 
>>     Now we have completely switched to irqdomain, so clean up transition code
>>     in IOAPIC drivers.
>> 
>>     Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>>     Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>     Cc: Tony Luck <tony.luck@intel.com>
>>     Cc: Joerg Roedel <joro@8bytes.org>
>>     Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>>     Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>     Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>     Cc: Grant Likely <grant.likely@linaro.org>
>>     Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
>>     Cc: Bjorn Helgaas <bhelgaas@google.com>
>>     Cc: Randy Dunlap <rdunlap@infradead.org>
>>     Cc: Yinghai Lu <yinghai@kernel.org>
>>     Link: http://lkml.kernel.org/r/1402302011-23642-43-git-send-email-jiang.liu@linux.intel.com
>>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> 
>> Reverting this specific commit on linux-tip (3.19-mw) gets things working again under Xen.
>> Kernel .config is attached.
>> 
>> --
>> Sander
>> 

