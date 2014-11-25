Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaKYU2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:28:06 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47264 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaKYU2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:28:03 -0500
Message-ID: <5474E640.7020206@interlog.com>
Date: Tue, 25 Nov 2014 15:27:44 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Akers, Jason B" <jason.b.akers@intel.com>,
        Phillip Susi <psusi@ubuntu.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
CC: "Karkra, Kapil" <kapil.karkra@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] sg3_utils: Added hybrid information log utility
References: <20141029195400.5225.96984.stgit@stg-AndroidDev-VirtualBox> <20141029195720.5225.51331.stgit@stg-AndroidDev-VirtualBox> <5473CE5C.7010300@ubuntu.com> <372C7AE269BA5E4D92B1082F530ED4B88A13F692@ORSMSX110.amr.corp.intel.com>
In-Reply-To: <372C7AE269BA5E4D92B1082F530ED4B88A13F692@ORSMSX110.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-11-25 02:13 PM, Akers, Jason B wrote:
> Hi Phillip,
> It turns out that this patch was based on an old github repository that doesn't appear to be updated. Doug Gilbert reached out after the initial RFC and directed us to his page (http://sg.danny.cz/sg/) where he has updated sg3_utils code.
>
> As we continue to work through the feedback from our SSHD kernel patches, I'm going to follow up with Doug again on sg3_utils.

Hi,
As discussed earlier in this thread adding a new utility
for each log page like sg_sat_get_hybrid_log would lead to
hundreds of utilities. There are now these groups of
storage related pages (with user space utilities to decode
them shown in parentheses):
   - SCSI VPD pages  (sg_vpd (sdparm and legacy sg_inq))
   - SCSI mode pages (sdparm and sg_modes)
   - SCSI log pages  (sg_logs)
   - ATA GP log pages (from 1.40 sg_sat_read_gplog)
   - ATA SMART log pages (smartctl)

At the start of this thread the proposed patch was very
close to the release of sg3_utils version 1.40 and Hannes
Reinecke contributed a more general approach:
sg_sat_read_gplog which I did incorporate. Currently it
only decodes pages to hex.

Please look at that utility (i.e. sg_sat_read_gplog) as the
basis for adding ATA GP log page decoding such as the SATA
hybrid information page. Please send patches against its source.

Doug Gilbert


>> -----Original Message-----
>> From: Phillip Susi [mailto:psusi@ubuntu.com]
>> Sent: Monday, November 24, 2014 4:34 PM
>> To: Akers, Jason B; linux-ide@vger.kernel.org
>> Cc: Karkra, Kapil; Williams, Dan J; linux-kernel@vger.kernel.org;
>> dgilbert@interlog.com
>> Subject: Re: [RFC PATCH] sg3_utils: Added hybrid information log utility
>>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA512
>>
>> On 10/29/2014 03:57 PM, Jason B. Akers wrote:
>>> From: Kapil Karkra <kapil.karkra@intel.com>
>>>
>>> A solid state hybrid drive (SSHD) is a hard drive with a small
>>> embedded NAND. Host drivers can manage this NAND using the
>> commands
>>> defined by SATA 3.2 standard. One SATA command that provides
>>> visibility into the SSHD's cache behavior is get hybrid log command.
>>> This augmentation allows users to issue the command as
>>> follows:
>>>
>>> sg_sat_get_hybrid_log /dev/sdc assuming /dev/sdc is an SSHD.
>>>
>>> patch applies to the following sourcebase from where to clone:
>>> https://github.com/hreinecke/sg3_utils.git
>>
>> I cloned that repo and the patch does not apply cleanly.  git am -3 says the
>> referenced blobs are not found and it has conflicts in src/Makefile.am.  I
>> manually fixed that up and then it fails to link due to unresolved externals.
>>
>>
>>
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1
>>
>> iQEcBAEBCgAGBQJUc85UAAoJENRVrw2cjl5RR3YIAJOF0fcTkF5pM0OIA87hK8k
>> 8
>> ujwflBTy66ZbPzXMD97cTGYQ6gPp3UCeT/ZcElBfrGGAuD5u/ETXMJY7lqAZgYt
>> K
>> bELPv6oLhz3ya2IO442sUlRYO4dVfwhsnak+2rLiQkXCy4WKSJ1EYiMIP/VHj8ne
>> 5e8VYkuc0KamKjvT4v6EwJ7tM0blfJbYgmFGruIxOSgCAo94Zp9thAcctb9PbRex
>> HnPTcnw5cI1sCoLf5fJafhc9w/1H45WjJTnGF7zs4hq/GGsYCwryvI0ovwAzU9ST
>> R3jRvE+70oiyQDsj9EBak63hRYIAd8QzQ3TkCjaM5E1XHSU7vTnxvxAjKb4ZyF4=
>> =a8Vh
>> -----END PGP SIGNATURE-----

