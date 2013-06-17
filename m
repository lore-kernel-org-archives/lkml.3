Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab3FQKbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:31:53 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39407 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab3FQKbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:31:51 -0400
Message-ID: <51BEE58F.5050204@linux.vnet.ibm.com>
Date: Mon, 17 Jun 2013 16:01:43 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "ananth@in.ibm.com" <ananth@in.ibm.com>, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] Re: [Patch] MCE, APEI: Don't enable CMCI when Firmware
 First mode is set in
References: <3908561D78D1C84285E8C5FCA982C28F2DA47F03@ORSMSX101.amr.corp.intel.com> <20130614181721.11206.95341.stgit@localhost.localdomain> <20130615144830.GA13310@pd.tnic> <51BEB3F5.8070002@gmail.com> <20130617070650.GA7203@pd.tnic> <20130617081103.GA4197@naverao1-tp.in.ibm.com> <20130617082135.GB7203@pd.tnic>
In-Reply-To: <20130617082135.GB7203@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061710-7014-0000-0000-0000033074CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 01:51 PM, Borislav Petkov wrote:
> On Mon, Jun 17, 2013 at 01:41:03PM +0530, Naveen N. Rao wrote:
>> Yes, we used to poll since we do not get notified via MCE/CMCI.
>> However, with firmware first set in CMC structure, the firmware is
>> now controlling all corrected error reporting for these banks. So, we
>> should not be looking at these MCA banks at all.
>
> Ok,
>
> then the bank polling disabling part should be generic code (i.e., not
> in mce_intel) since it is part of the APEI crap. The CMCI disabling
> should be Intel-specific only as AMD has a similar mechanism which we'll
> need to disable at some point too.

Ok, I'll move mce_disable_bank() to mce.c and re-structure the patch 
around that.

Thanks,
Naveen

