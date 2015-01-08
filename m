Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbbAHMK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:10:57 -0500
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:49224 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756433AbbAHMKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:10:55 -0500
Message-ID: <54AE73C7.90009@nexus-software.ie>
Date: Thu, 08 Jan 2015 12:10:47 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Darren Hart <dvhart@infradead.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie> <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie> <20150106073634.GB59754@vmdeb7> <54ABE67B.1070706@nexus-software.ie> <AF233D1473C1364ABD51D28909A1B1B7326E0C25@PGSMSX105.gar.corp.intel.com>
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B7326E0C25@PGSMSX105.gar.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/15 23:45, Ong, Boon Leong wrote:
>> Since BIOS and grub code both use 0x00000000 as the 'off' address I think it
>> makes sense for the kernel to continue to use that address.
>
> Just add on top of what Daren mentioned in another mail, based on the Quark document,
> the base address can start from zero. Say lo=0, hi=0, and WM & RM may be changed from default value,
> 1st 1KiB will be marked as IMR. It seems to me that there is no good way to test if an IMR is 'occupied' and/or 'enabled'
> since enable-bit is not available. But, what is benefit of testing against lo=0 & hi=0? The logic to calculate size will work under
> lo=0 & hi=0 anway.

Hi Boon Leong.

I think it does make sense to add a check for rmask and wmask in the 
'access all' state when determining if an IMR is enabled on X1000 or not.

>> My own view is that it's not really desirable and easier to debug IMRs
>> generally on a platform if overlaps aren't allowed.
> I do agree on the benefit listed above. Perhaps, you can add explanation here
> to mention the design decision.

Will do.


