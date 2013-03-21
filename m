Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab3CUNuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:50:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab3CUNuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:50:51 -0400
Date: Thu, 21 Mar 2013 09:50:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s
 page-size boundary requirement
Message-ID: <20130321135027.GB3934@redhat.com>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
 <20130316040228.15064.28019.stgit@localhost6.localdomain6>
 <877gl3koay.fsf@xmission.com>
 <20130320135716.GE17274@redhat.com>
 <87txo5bxk4.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txo5bxk4.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 01:55:55PM -0700, Eric W. Biederman wrote:

[..]
> If core counts on the high end do more than double every 2 years we
> might have a problem.  Otherwise making everything mmapable seems easy
> and sound.

We already have mechanism to translate file offset into actual physical
address where data is. So if we can't allocate one contiguous chunk of
memory for notes, we should be able to break it down into multiple
page aligned areas and map offset into respective discontiguous areas
using vmcore_list.

Thanks
Vivek
