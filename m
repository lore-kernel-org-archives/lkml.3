Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936868Ab3DJU2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:28:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934822Ab3DJU2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:28:54 -0400
Date: Wed, 10 Apr 2013 16:28:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4 0/4] x86, kdump: Fix crashkernel high with old
 kexec-tools
Message-ID: <20130410202842.GG6602@redhat.com>
References: <1365622759-2133-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365622759-2133-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:39:15PM -0700, Yinghai Lu wrote:
> Vivek found some problems with old kexec-tools.
> 
> We keep the old crashkernel=X to old behavoir, so it will not break
> old kexec-tools.
> Add crashkernel=X,high to support new kexec-tools that supports loading high.
> when high is used, memblock will search from top to low.
> if the allocated one is above 4G, kernel will try to auto allocate
> 72M under 4G for swiotlb.
> user could crashkernel=Y,low to change 72M to other value.
> 
> -v2:	reorder the patch sequences
> 	crashkernel=X,high, crashkernel=Y,low only handle simple form.
> 	crashkernel=X will override crashkernel=X;high crashkernel=Y;low
> -v3:	update description in kernel-parameters.txt
> 	update get_last_crashkernel and _simple checking about suffix.
> -v4:	update to use ,high again, and also not abuse parse_crashkernel_simple
> 

This series looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
