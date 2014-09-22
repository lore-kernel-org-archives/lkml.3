Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaIVSuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:50:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37211 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaIVSuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:50:09 -0400
Message-ID: <54206F60.7020703@canonical.com>
Date: Mon, 22 Sep 2014 13:50:08 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: bruce.lucas@mongodb.com,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptfusion: enable no_write_same in scsi_host_template
References: <1411408690-4766-1-git-send-email-chris.j.arges@canonical.com> <20140922180220.GA10166@infradead.org> <5420679D.3070406@canonical.com> <20140922181929.GA11319@infradead.org>
In-Reply-To: <20140922181929.GA11319@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/22/2014 01:19 PM, Christoph Hellwig wrote:
> On Mon, Sep 22, 2014 at 01:17:01PM -0500, Chris J Arges wrote:
>>>
>> I've only been able to reproduce this on VMWare. There is a pretty
>> straightforward reproducer in the BugLink if there is any interest in
>> verifying on hardware.
>>
>> How would you recommending blacklisting only VMWare guests in this case?
> 
> Can you check what PCI subdevice and subvendor IDs the device you can
> reproduce it with have?  If the subvendor is Vmware that would be easy,
> if not the Avago people might be able to help with a device specific
> VMware identification.  If that fails we have kernel helpers to
> identify the hypervisor, but I'd rather avoid that as it would also
> trigger for PCI pass through devices.
> 

Christoph,

Thanks for the input, and now I realize how broad the earlier patch was.
I'll see if I can quirk on the vendor ID to enable no_write_same, in the
meantime I'll see if there are any ways to fix the underlying issue
without adding such a quirk.

Thanks,
--chris j arges
