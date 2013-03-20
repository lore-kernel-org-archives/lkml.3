Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3CTOlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:41:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056Ab3CTOlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:41:23 -0400
Date: Wed, 20 Mar 2013 10:41:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        dmitry.kasatkin@intel.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, serge@hallyn.com, morgan@kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH 3/4] capability: Create a new capability CAP_SIGNED
Message-ID: <20130320144110.GF17274@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
 <1363379758-10071-4-git-send-email-vgoyal@redhat.com>
 <51438EDB.3050300@schaufler-ca.com>
 <alpine.LRH.2.02.1303201603380.9518@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1303201603380.9518@tundra.namei.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 04:07:58PM +1100, James Morris wrote:
> On Fri, 15 Mar 2013, Casey Schaufler wrote:
> 
> > Capabilities aren't just random attribute bits. They
> > indicate that a task has permission to violate a
> > system policy (e.g. change the mode bits of a file
> > the user doesn't own).
> 
> Casey's right here, as well he should be.
> 

Ok, so how do I go about it (Though I have yet to spend more time
understanding the suggestion in couple of other mails. I will do that
now)

I am not sure why CAP_COMPROMISE_KERNEL(CAP_MODIFY_KERNEL) is any
different. When secureboot is enabled, kernel will take away that
capability from all the processes. So kernel became a decision maker
too whether processes have CAP_COMPROMISE_KERNEL or not based on
certain other factors like secureboot is enabled or not.

If I draw a parallel, then based on certain other factors (binary is
signed and secureboot trust has been extended to this binary), why
can't kernel take a decision to give extra capability to this binary.

In fact instead of new capabiilty, I guess upon successful signature
verification, one could just give CAP_MODIFY_KERNEL to process.

I am just trying to understand better that why capability is not
a good fit here (Especially given the fact that CAP_MODIFY_KERNEL
is making progress and it seems reasonable to me to extend the
secureboot trust to validly signed processes. Like modules, their
signatures have been verified and they should be allowed to modify
kernel).

Thanks
Vivek
