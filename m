Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3CACRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:17:13 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:38878 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3CACRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:17:11 -0500
Message-ID: <1362104227.9158.41.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Date: Thu, 28 Feb 2013 21:17:07 -0500
In-Reply-To: <20130228213534.GF11360@redhat.com>
References: <20130228151333.GB11360@redhat.com>
	 <1362079419.2908.390.camel@falcor1.watson.ibm.com>
	 <20130228213534.GF11360@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030102-3620-0000-0000-0000016BE248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 16:35 -0500, Vivek Goyal wrote:
> On Thu, Feb 28, 2013 at 02:23:39PM -0500, Mimi Zohar wrote:
> 
> [..]
> > I would suggest that the ima_appraise_tcb, which is more restrictive, be
> > permitted to replace the secureboot policy.
> 
> Also ima_appraise_tcb is not necessarily more restrictive. It takes
> appraises only for root user. Files for rest of users are not appraised.

Ok, good point.  

> In general case of "memory locked execution of signed binary" I was
> hoping to give user a flexibility to do appraisal either for root
> or both root and non-root user.
> 
> For the time being I can hardcode things only for root user but the
> moment somebody will extend functionality for non-root user, again
> we will run into the issue that ima_appraise_tcb is not superset so
> we can't allow that.

So we can agree that the 'ima_appraise_tcb' policy is more restrictive
for root owned files.  So as long as the 'ima_appraise_tcb' policy
precedes the secureboot integrity policy, we should be good.

thanks,

Mimi

