Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699Ab3D2Tgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:36:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099Ab3D2Tgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:36:47 -0400
Date: Mon, 29 Apr 2013 15:36:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 5/8] vmcore: copy ELF note segments in the 2nd kernel
 per page vmcore objects
Message-ID: <20130429193611.GQ8204@redhat.com>
References: <20130413002000.18245.21513.stgit@localhost6.localdomain6>
 <20130413002133.18245.91528.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413002133.18245.91528.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 09:21:33AM +0900, HATAYAMA Daisuke wrote:

[..]
> ELF notes are per-cpu, so total size of ELF note segments increases
> according to the number of CPUs. The current maximum number of CPUs on
> x86_64 is 5192, and there's already system with 4192 CPUs in SGI,
> where total size amounts to 1MB. This can be larger in the neare
> futrue or possibly even now on another architecture. Thus, to avoid
> the case where memory allocation for large block fails, we allocate
> vmcore objects per pages.

IIRC, eric had suggested using vmalloc() and remap_vmalloc_range(). What's
wrong with that? That should keep your vc_list relatively smaller.

Thanks
Vivek
