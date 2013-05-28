Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401Ab3E1OpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:45:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934359Ab3E1OpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:45:20 -0400
Date: Tue, 28 May 2013 10:44:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Message-ID: <20130528144447.GE7088@redhat.com>
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <20130524143644.GD18218@redhat.com>
 <20130524170626.2ac06efe@holzheu>
 <20130524152849.GF18218@redhat.com>
 <87mwrkatgu.fsf@xmission.com>
 <51A006CF.90105@gmail.com>
 <87k3mnahkf.fsf@xmission.com>
 <51A076FE.3060604@gmail.com>
 <20130525145217.0549138a@holzheu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130525145217.0549138a@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 02:52:17PM +0200, Michael Holzheu wrote:

[..]
> Therefore, if necessary, IMHO we can switch to the ELF header memory
> swap mechanism for s390 in the kernel. Of course we would then also
> have to adjust the (disabled) kexec code.

I think it is a good idea to fix it in s390 kernel so that
copy_oldmem_page() does not do any swapping and fix the ELF header
generation logic and any swapping is done in ELF headers.

Agreed that we need to fixed s390 kexec-tools too. I guess our best
bet would be to parse the kernel version and fix headers only for
newer kernel versions. This assumes that first kernel and second kernel
are same but that's the case for majority of the people anyway. So for
majority of people, change will be backward compatible.

Thanks
Vivek
