Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3JHDyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:54:22 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:56574 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3JHDyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:54:21 -0400
In-Reply-To: <52535098.70405@gmail.com>
References: <20131004102532.1612.24185.stgit@f19-x64> <20131004103043.1612.56980.stgit@f19-x64> <52535098.70405@gmail.com>
Subject: Re: [PATCH 02/19] Make vma_dump_size() generic
X-KeepSent: FBABC377:C12D8795-65257BFE:00151B4E;
 type=4; name=$KeepSent
To: Ryan Mallon <rmallon@gmail.com>
Cc: adobriyan@gmail.com, akpm@linux-foundation.org, amwang@redhat.com,
        ananth@linux.vnet.ibm.com, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, avagin@openvz.org,
        d.hatayama@jp.fujitsu.com, eparis@redhat.com, gorcunov@openvz.org,
        hch@lst.de, james.hogan@imgtec.com, jeremy.fitzhardinge@citrix.com,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        mhiramat@redhat.com, oleg@redhat.com, rdunlap@xenotime.net,
        roland@hack.frob.com, suzuki@linux.vnet.ibm.com,
        tarundsk@linux.vnet.ibm.com, tj@kernel.org,
        torvalds@linux-foundation.org, vapier@gentoo.org, xemul@parallels.com
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFFBABC377.C12D8795-ON65257BFE.00151B4E-65257BFE.00154301@in.ibm.com>
From: Janani Venkataraman1 <jananive@in.ibm.com>
Date: Tue, 8 Oct 2013 09:22:46 +0530
X-MIMETrack: Serialize by Router on d23ml068/23/M/IBM(Release 8.5.3FP2HF29 | July 24, 2012) at
 08/10/2013 09:22:47
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100803-5816-0000-0000-00000A41A7F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





From:	Ryan Mallon <rmallon@gmail.com>
To:	Janani Venkataraman1/India/IBM@IBMIN,
            linux-kernel@vger.kernel.org,
Cc:	amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
            aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
            jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
            suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
            adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com,
            vapier@gentoo.org, roland@hack.frob.com, tj@kernel.org,
            ananth@linux.vnet.ibm.com, gorcunov@openvz.org,
            avagin@openvz.org, oleg@redhat.com, eparis@redhat.com,
            d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
            akpm@linux-foundation.org, torvalds@linux-foundation.org
Date:	10/08/2013 05:52 AM
Subject:	Re: [PATCH 02/19] Make vma_dump_size() generic



On 04/10/13 20:30, Janani Venkataraman wrote:
> From:Suzuki K. Poulose <suzuki@in.ibm.com>
>
> vma_dump_size calculates the file size of a vma area in the core file. It
> assumes the vma belongs to the "current". Make it generic to work for any
task.
> This will be reused by application core dump infrastructure.
>
> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
> ---

> -static unsigned long vma_dump_size(struct vm_area_struct *vma,
> +unsigned long vma_dump_size(struct task_struct *p, struct vm_area_struct
*vma,
>  		 		 		 		 		 unsigned long
mm_flags)
>  {
>  #define FILTER(type)    (mm_flags & (1UL << MMF_DUMP_##type))
> @@ -143,10 +143,18 @@ static unsigned long vma_dump_size(struct
vm_area_struct *vma,
>  		 		  * Switch to the user "segment" for get_user(),
>  		 		  * then put back what elf_core_dump() had in
place.
>  		 		  */
> -		 		 set_fs(USER_DS);
> - 		 		 if (unlikely(get_user(word, header)))
> - 		 		 		 word = 0;
> -		 		 set_fs(fs);
> +		 		 if (p->mm == current->mm) {
> +		 		 		 mm_segment_t fs = get_fs();

It looks like you missed the removal of the old:

		 mm_segment_t fs = get_fs();

above? Just below if (FILTER(ELF_HEADERS)).

Yes thats correct. I will remove it. Thanks for pointing it out.

Thanks
Janani

~Ryan



