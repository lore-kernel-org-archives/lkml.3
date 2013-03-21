Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab3CUO56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:57:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab3CUO55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:57:57 -0400
Date: Thu, 21 Mar 2013 10:57:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s
 page-size boundary requirement
Message-ID: <20130321145743.GI3934@redhat.com>
References: <87txo5bxk4.fsf@xmission.com>
 <20130321.122501.82758179.d.hatayama@jp.fujitsu.com>
 <8738vp75cy.fsf@xmission.com>
 <20130321.151428.393714972.d.hatayama@jp.fujitsu.com>
 <87ip4l1d1q.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip4l1d1q.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:29:05PM -0700, Eric W. Biederman wrote:

[..]
> Preserving the actual PT_LOAD segments p_paddr and p_memsz values is
> important. p_offset we can change as much as we want.  Which means there
> can be logical holes in the file between PT_LOAD segments, where we put
> the extra data needed to keep everything page aligned.

Agreed. If one modifies p_paddr then one will have to modify p->vaddr
too. And user space tools look at p->vaddr and where is the corresponding
physical address. Keeping p_vaddr and p_paddr intact makes sense.

Thanks
Vivek
