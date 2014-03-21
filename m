Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbaCURfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:35:25 -0400
Received: from kanga.kvack.org ([205.233.56.17]:45137 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbaCURfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:35:22 -0400
Date: Fri, 21 Mar 2014 13:35:19 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        jmoyer@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>, miaox@cn.fujitsu.com,
        linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] aio: fix the confliction of read events and migrating ring page
Message-ID: <20140321173519.GB23173@kvack.org>
References: <532A80B1.5010002@cn.fujitsu.com> <20140320143207.GA3760@redhat.com> <20140320163004.GE28970@kvack.org> <532B9C54.80705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532B9C54.80705@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

On Fri, Mar 21, 2014 at 09:56:36AM +0800, Gu Zheng wrote:
> This one is based on linux-next which has merged the following patch:
> commit 692c9b8c5ee8d263bb8348171f0bebd3d84eb2c1
> Author: Tang Chen <tangchen@cn.fujitsu.com>
> Date:   Mon Mar 10 16:15:33 2014 +0800
> aio, memory-hotplug: Fix confliction when migrating and accessing ring pages.
> 
> With this patch, the update of the ring's head pointer is safe because it is protected
> by completion_lock, so we do not need to enlarge the ring_lock protection region.
> And on the other side, if we take the ring_lock over the entire page migration
> operation, reading events will be affected if the page migration is going.

I have dropped this particular change of Tang's from my aio-next tree.  
The spinlock addition in the read events code path is not needed if we 
take the ring_lock mutex in the page migration code path.  This will 
ensure that we aren't needlessly regressing performance.  I'll send out 
my replacement patch in a couple of minutes.

		-ben
-- 
"Thought is the essence of where you are now."
