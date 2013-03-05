Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3CEJbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:31:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44594 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab3CEJbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:31:05 -0500
X-IronPort-AV: E=Sophos;i="4.84,786,1355068800"; 
   d="scan'208";a="6816564"
Message-ID: <5135BAE8.8050405@cn.fujitsu.com>
Date: Tue, 05 Mar 2013 17:29:12 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/20] vmcore, sysfs: export ELF note segment size
 instead of vmcoreinfo data size
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6> <20130302083605.31252.26646.stgit@localhost6.localdomain6>
In-Reply-To: <20130302083605.31252.26646.stgit@localhost6.localdomain6>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 17:30:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 17:30:02
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月02日 16:36, HATAYAMA Daisuke 写道:
> p_memsz member of program header entry with PT_NOTE type needs to have
> size of the corresponding ELF note segment. Currently, vmcoreinfo
> exports data part only. If vmcoreinfo reachs vmcoreinfo_max_size, then
> in merge_note_headers_elf{32,64}, empty ELF note header cannot be
> found or buffer overrun can happen.
> 
> Note: kexec-tools assigns PAGE_SIZE to p_memsz for other ELF note
> types. Due to the above reason, the same issue occurs if actual ELF
> note data exceeds (PAGE_SIZE - 2 * KEXEC_NOTE_HEAD_BYTES).
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
> 
>  kernel/ksysfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
> index 6ada93c..97d2763 100644
> --- a/kernel/ksysfs.c
> +++ b/kernel/ksysfs.c
> @@ -126,7 +126,7 @@ static ssize_t vmcoreinfo_show(struct kobject *kobj,
>  {
>  	return sprintf(buf, "%lx %x\n",
>  		       paddr_vmcoreinfo_note(),
> -		       (unsigned int)vmcoreinfo_max_size);
> +		       (unsigned int)sizeof(vmcoreinfo_note));
>  }
>  KERNEL_ATTR_RO(vmcoreinfo);

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

>  
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 

