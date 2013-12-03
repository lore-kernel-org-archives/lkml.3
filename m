Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3LCDVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:21:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38201 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab3LCDVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:21:09 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <529D4DF5.80502@jp.fujitsu.com>
Date: Tue, 3 Dec 2013 12:20:21 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>,
        "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
Subject: Re: [PATCH] x86, efi: add efi_whitelist_table to use all efi variable
 storage
References: <528C740A.6010407@jp.fujitsu.com>  <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>  <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com>  <1385078632.12107.3.camel@x230> <528EF87D.4050300@jp.fujitsu.com>  <528EF9CE.2070305@jp.fujitsu.com> <1385142450.2884.1.camel@x230>
In-Reply-To: <1385142450.2884.1.camel@x230>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/23 2:47), Matthew Garrett wrote:
> On Fri, 2013-11-22 at 15:29 +0900, Yasuaki Ishimatsu wrote:
>
>> +			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "PRIMEQUEST"),
>
> Can we guarantee that no Primequests have this issue? Can we guarantee
> that that no prior firmware versions have this issue? Can we guarantee
> that no future firmware versions will have this issue?
>

Sorry for the late reply. I contacted our firmware team to confirm them.
They said that current implementation, thereshold is 5KB, is strange.

Currently many EFI firmwares are based on EFI Development Kit (EDK).
Accoding to EDK source, gc on boot time runs when free space of nvram
is less than MaximumVariableSize of QueryVariableInfo(). In my system
MaximumVariableSize is 1KB. So when free space reaches less than 5KB
and I reboot the system, gc does not run on boot time in my system.

Threshold of gc depends on a system. So at least, 5KB threshold must be
changed on each system.

Thanks,
Yasuaki Ishimatsu


