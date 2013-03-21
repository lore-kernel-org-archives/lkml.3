Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3CUPVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:21:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab3CUPVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:21:39 -0400
Date: Thu, 21 Mar 2013 11:21:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s
 page-size boundary requirement
Message-ID: <20130321152124.GJ3934@redhat.com>
References: <8738vp75cy.fsf@xmission.com>
 <20130321.151428.393714972.d.hatayama@jp.fujitsu.com>
 <87ip4l1d1q.fsf@xmission.com>
 <20130321.154650.424925595.d.hatayama@jp.fujitsu.com>
 <87a9pxz0wv.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9pxz0wv.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:07:12AM -0700, Eric W. Biederman wrote:

[..]
> I think the two having different contents violates the principle of
> least surprise.
> 
> I think exporting the old memory as the ``extra data'' is the least
> surprising and the easiest way to go.
> 
> I don't mind filling the extra data with zero's but I don't see the
> point.

I think only question would be if there is a problem in reading memory
areas which BIOS has kept reserved or possibly not exported. Are there
any surprises to be expected. (machines reboots while trying to reboot
a particular memory location etc).

So trying to zero the extra data can make theoritically make it somewhat
safer.

So if starting or end address of PT_LOAD header is not aligned, why
not we simply allocate a page. Copy the relevant data from old memory,
fill rest with zero. That way mmap and read view will be same. There
will be no surprises w.r.t reading old kernel memory beyond what's 
specified by the headers.

And in practice I am not expecting many PT_LOAD ranges which are unaligned.
Just few. And allocating a few 4K pages should not be a big deal.

And vmcore_list will help us again map whether pfn lies in old memory
or new memory. 

Thanks
Vivek
