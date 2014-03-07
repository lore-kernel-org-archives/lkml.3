Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaCGPd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:33:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbaCGPdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:33:24 -0500
Date: Fri, 7 Mar 2014 10:32:59 -0500
From: Dave Jones <davej@redhat.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        cl@linux-foundation.org, penberg@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: slub: fix leak of 'name' in sysfs_slab_add
Message-ID: <20140307153259.GA778@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Vladimir Davydov <vdavydov@parallels.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	cl@linux-foundation.org, penberg@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20140306211141.GA17009@redhat.com>
 <5319649C.3060309@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5319649C.3060309@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 10:18:04AM +0400, Vladimir Davydov wrote:
 > [adding Andrew to Cc]
 > 
 > On 03/07/2014 01:11 AM, Dave Jones wrote:
 > > The failure paths of sysfs_slab_add don't release the allocation of 'name'
 > > made by create_unique_id() a few lines above the context of the diff below.
 > > Create a common exit path to make it more obvious what needs freeing.
 > > 
 > > Signed-off-by: Dave Jones <davej@fedoraproject.org>
 > > 
 > 
 > Since this function was modified in the mmotm tree, I would propose
 > something like this on top of mmotm to avoid further merge conflicts:
 
Looks good to me.

thanks,

	Dave
