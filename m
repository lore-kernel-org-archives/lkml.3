Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab3JUVcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:32:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25382 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3JUVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:32:32 -0400
Date: Mon, 21 Oct 2013 14:27:57 -0700 (PDT)
From: Seth Goldberg <seth.goldberg@oracle.com>
X-X-Sender: sethg@bergsoft
To: "=?ISO-8859-7?Q?Vladimir_'=F6-coder=2Fphcoder'_Serbinenko?=" 
	<phcoder@gmail.com>
cc: The development of GNU GRUB <grub-devel@gnu.org>, keir@xen.org,
        david.woodhouse@intel.com, stefano.stabellini@eu.citrix.com,
        linux-kernel@vger.kernel.org, ross.philipson@citrix.com,
        jbeulich@suse.com, boris.ostrovsky@oracle.com, xen-devel@lists.xen.org,
        richard.l.maliszewski@intel.com, ian.campbell@citrix.com
Subject: Re: EFI and multiboot2 devlopment work for Xen
In-Reply-To: <52659C34.6010508@gmail.com>
Message-ID: <alpine.GSO.2.00.1310211424200.2162@oretfbsg>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl> <alpine.GSO.2.00.1310211348530.2162@oretfbsg> <52659C34.6010508@gmail.com>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-63267017-1382390878=:2162"
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-63267017-1382390878=:2162
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



Quoting Vladimir '=CF=86-coder/phcoder' Serbinenko, who wrote the following=
 on...:

> On 21.10.2013 22:53, Seth Goldberg wrote:
>>
>>
>> Quoting Daniel Kiper, who wrote the following on Mon, 21 Oct 2013:
>>
>>> Hi,
>>>
>>> During work on multiboot2 protocol support for Xen it was discovered
>>> that memory map passed via relevant tag could not represent wide range
>>> of memory types available on EFI platforms. Additionally, GRUB2
>>> implementation calls ExitBootServices() on them just before jumping
>>> into loaded image. In this situation loaded system could not clearly
>>> identify reserved memory regions, EFI runtime services regions and
>>> others.
>>
>>   Yes, that is exactly why we added full support to pass the entire UEFI
>> memory map via a new tag.
>>
> Can you send this patch? Or provide a link to publically available
> source? I think we can accept it with probably just minor changes.
>

   Sure :).  Just as an FYI, the changes are available in one of the zips f=
rom:

http://www.oracle.com/technetwork/opensource/systems-solaris-1562786.html

   (their size is rather comical of course, but only because they include A=
LL=20
FOSS source shipped with Solaris 11.1).

   I'll try to isolate that change and base it against the current trunk.=
=20
We may need to change the tag id, as I ended up using an OEM-specific numbe=
r=20
for it; I didn't want to conflict with new tags.

  Thanks,
  --S
---559023410-63267017-1382390878=:2162--
