Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbaDIDDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 23:03:14 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:31857 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756659AbaDIDDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 23:03:11 -0400
Message-ID: <5344B86C.8000905@akamai.com>
Date: Tue, 08 Apr 2014 23:03:08 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
CC: "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
References: <cover.1396645124.git.jbaron@akamai.com> <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com> <20140408090924.GE30077@pd.tnic> <5344754B.8050909@akamai.com> <3908561D78D1C84285E8C5FCA982C28F31E21864@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31E21864@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 06:34 PM, Luck, Tony wrote:
>>> Btw, this driver is polling, AFAICT. Doesn't e3-12xx support the CMCI
>>> interrupt which you can feed into this driver directly and thus not need
>>> the polling at all?
>> On the system with the ce and ue events that I'm testing on, I don't see
>> 'MCE' nudge above 0, in /proc/interrupts. So I think that implies that
>> we are not getting any CMCI there?
> CMCI will bump up the "THR" (Threshold) entries in /proc/interrupts.

Ok, so on the system with ue and ce events (as reported by driver
and confirmed with a memory scanner), "THR" is 0 across
all cpus, and I see no machine checks in the logs...

>> So if possible maybe we can confirm with Intel whether we expect an MCE
>> for memory errors...
> MCG_CAP bit 10 tells you whether a given processor implements CMCI.
> If that is set - then MCi_CTL2 bit 30 indicates whether a given bank
> supports it (Linux tries to set this bit, if it sticks, then it knows that CMCI
> is supported - Linux also assigns ownership of the bank to the first cpu
> to successfully set it (since a bank may be shared by multiple threads/cores
> on a package).
>
> Consumed uncorrectable errors should generate a machine check. Which
> on the E3-12xx series will be a fatal machine check: MCi_STATUS.PCC=1
>
> -Tony
>

Hmmm...as I said, I'm not getting any machine checks with ue errors. I've
got a fairly old kernel on the system atm, I will try loading a newer kernel,
to see if that makes any difference...

Thanks,

-Jason

