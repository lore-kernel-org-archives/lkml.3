Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaAGMRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:17:19 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:45728 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaAGMQa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 7 Jan 2014 07:16:30 -0500
Message-Id: <52CBFE27020000780011112F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 07 Jan 2014 12:16:23 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Yijing Wang" <wangyijing@huawei.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Hanjun Guo" <guohanjun@huawei.com>, <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: Use dev_is_pci() to check whether it is pci
 device
References: <1386243245-34280-1-git-send-email-wangyijing@huawei.com>
 <20131231145111.GB3349@phenom.dumpdata.com>
In-Reply-To: <20131231145111.GB3349@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 31.12.13 at 15:51, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Thu, Dec 05, 2013 at 07:34:05PM +0800, Yijing Wang wrote:
>> Use PCI standard marco dev_is_pci() instead of directly compare
>> pci_bus_type to check whether it is pci device.
> 
> Jan, you OK with this?

Yes, sure - I simply wasn't aware of that wrapper.

Jan

>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/xen/dbgp.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/xen/dbgp.c b/drivers/xen/dbgp.c
>> index f3ccc80..8145a59 100644
>> --- a/drivers/xen/dbgp.c
>> +++ b/drivers/xen/dbgp.c
>> @@ -19,7 +19,7 @@ static int xen_dbgp_op(struct usb_hcd *hcd, int op)
>>  	dbgp.op = op;
>>  
>>  #ifdef CONFIG_PCI
>> -	if (ctrlr->bus == &pci_bus_type) {
>> +	if (dev_is_pci(ctrlr)) {
>>  		const struct pci_dev *pdev = to_pci_dev(ctrlr);
>>  
>>  		dbgp.u.pci.seg = pci_domain_nr(pdev->bus);
>> -- 
>> 1.7.1
>> 
>> 



