Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3CUP2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229Ab3CUP2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:28:07 -0400
Date: Thu, 21 Mar 2013 11:27:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s
 page-size boundary requirement
Message-ID: <20130321152751.GK3934@redhat.com>
References: <8738vp75cy.fsf@xmission.com>
 <20130321.151428.393714972.d.hatayama@jp.fujitsu.com>
 <87ip4l1d1q.fsf@xmission.com>
 <20130321.154650.424925595.d.hatayama@jp.fujitsu.com>
 <87a9pxz0wv.fsf@xmission.com>
 <20130321152124.GJ3934@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321152124.GJ3934@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 11:21:24AM -0400, Vivek Goyal wrote:

[..]
> So if starting or end address of PT_LOAD header is not aligned, why
> not we simply allocate a page. Copy the relevant data from old memory,
> fill rest with zero. That way mmap and read view will be same. There
> will be no surprises w.r.t reading old kernel memory beyond what's 
> specified by the headers.

Copying from old memory might spring surprises w.r.t hw poisoned
pages. I guess we will have to disable MCE, read page, enable it
back or something like that to take care of these issues.

In the past we have recommended makedumpfile to be careful, look
at struct pages and make sure we are not reading poisoned pages.
But vmcore itself is reading old memory and can run into this
issue too.

Thanks
Vivek
