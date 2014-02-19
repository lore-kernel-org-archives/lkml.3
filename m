Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaBSTkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:40:45 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38830 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaBSTkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:40:43 -0500
Date: Wed, 19 Feb 2014 20:40:39 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mm: exclude memory less nodes from zone_reclaim
Message-ID: <20140219194039.GA5825@dhcp22.suse.cz>
References: <20140219082313.GB14783@dhcp22.suse.cz>
 <1392829383-4125-1-git-send-email-mhocko@suse.cz>
 <20140219171628.GE27108@linux.vnet.ibm.com>
 <20140219173259.GA5041@dhcp22.suse.cz>
 <20140219174940.GF27108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219174940.GF27108@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-02-14 09:49:41, Nishanth Aravamudan wrote:
> On 19.02.2014 [18:32:59 +0100], Michal Hocko wrote:
> > On Wed 19-02-14 09:16:28, Nishanth Aravamudan wrote:
[...]
> > > I don't think this will work, because what sets N_HIGH_MEMORY (and
> > > shouldn't it be N_MEMORY?)
> > 
> > This should be the same thing AFAIU.
> 
> I don't think they are guaranteed to be? And, in any case, semantically,
> we care if a node has MEMORY, not if it has HIGH_MEMORY?

I don't know. The whole MEMORY vs HIGH_MEMORY thing is really
confusing. But my understanding was that HIGH_MEMORY is superset of the
other one. But now that I look at the code again it seems that N_MEMORY
is the right thing to use here. I will repost the patch tomorrow if
other parts are good.

[...]
-- 
Michal Hocko
SUSE Labs
