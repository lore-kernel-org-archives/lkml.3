Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936192Ab3DITy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:54:27 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:28482 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936172Ab3DITy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:54:26 -0400
Message-ID: <1365536528.32127.56.camel@misato.fc.hp.com>
Subject: Re: [UPDATE][PATCH v2 2/3] resource: Add
 release_mem_region_adjustable()
From: Toshi Kani <toshi.kani@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ram Pai <linuxram@us.ibm.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        "Makphaibulchoke, Thavatchai" <thavatchai.makpahibulchoke@hp.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "tangchen@cn.fujitsu.com" <tangchen@cn.fujitsu.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>
Date: Tue, 09 Apr 2013 13:42:08 -0600
In-Reply-To: <20130409125141.bfe6e26142e5bb2ff229ed29@linux-foundation.org>
References: <1365457655-7453-1-git-send-email-toshi.kani@hp.com>
	 <20130409054825.GB7251@ram.oc3035372033.ibm.com>
	 <1365534150.32127.55.camel@misato.fc.hp.com>
	 <20130409125141.bfe6e26142e5bb2ff229ed29@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 12:51 -0700, Andrew Morton wrote:
> On Tue, 09 Apr 2013 13:02:30 -0600 Toshi Kani <toshi.kani@hp.com> wrote:
> 
> > > > +		/* look for the next resource if it does not fit into */
> > > > +		if (res->start > start || res->end < end) {
> > > > +			p = &res->sibling;
> > > > +			continue;
> > > > +		}
> > > 
> > > What if the resource overlaps. In other words, the res->start > start 
> > > but res->end > end  ? 
> > > 
> > > Also do you handle the case where the range <start,end> spans
> > > across multiple adjacent resources?
> > 
> > Good questions!  The two cases above are handled as error cases
> > (-EINVAL) by design.  A requested region must either match exactly or
> > fit into a single resource entry.  There are basically two design
> > choices in release -- restrictive or non-restrictive.  Restrictive only
> > releases under certain conditions, and non-restrictive releases under
> > any conditions.  Since the existing release interfaces,
> > __release_region() and __release_resource(), are restrictive, I intend
> > to follow the same policy and made this new interface restrictive as
> > well.  This new interface handles the common scenarios of memory
> > hot-plug operations well.  I think your example cases are non-typical
> > scenarios for memory hot-plug, and I am not sure if they happen under
> > normal cases at this point.  Hence, they are handled as error cases for
> > now.  We can always enhance this interface when we find them necessary
> > to support as this interface is dedicated for memory hot-plug.  In other
> > words, we should make such enhancement after we understand their
> > scenarios well.  Does it make sense?
> 
> Can you please update the comment to describe the above?  Because if
> one reviewer was wondering then later readers will also wonder.

Yes, I will update the comment and send an updated patch again.

Thanks,
-Toshi


