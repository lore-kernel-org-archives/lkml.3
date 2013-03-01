Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3CAMPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:15:17 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:58127 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3CAMPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:15:15 -0500
Message-ID: <1362140107.9158.101.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Fri, 01 Mar 2013 07:15:07 -0500
In-Reply-To: <1362102544.9158.35.camel@falcor1>
References: <20130228151333.GB11360@redhat.com>
	 <1362079419.2908.390.camel@falcor1.watson.ibm.com>
	 <20130228213534.GF11360@redhat.com>
	 <CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
	 <1362102544.9158.35.camel@falcor1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030112-3620-0000-0000-0000016D0952
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 20:49 -0500, Mimi Zohar wrote:
> On Thu, 2013-02-28 at 17:20 -0500, Eric Paris wrote:

> > The ima_tcb policy was meant to be larger than needed to determine a
> > trusted computing base, but it is clearly not a superset of what he is
> > hoping to accomplish.

The builtin measurement and appraisal policies are different.  In order
not to miss a measurement, the measurement policy measures everything
read/executed by root.   Userspace can constrain the policy by defining
rules based on LSM labels.  The appraisal policy measures everything
owned by root.  Userspace might want to add rules to appraise additional
files.

We can not OR the measurement builtin and userspace policies, as the
userspace policy constrains the builtin policy, but for appraisal we
could.  Perhaps we should define two rule chains, one for the builtin
appraisal rules and another for all other rules.

When secure boot is defined, instead of having a NULL policy, the
default policy would be the secureboot integrity policy.  These rules
would be added to the builtin appraisal rule chain.  If the
'ima_appraise_tcb'  boot commandline option is specified, these rules
would also be added to the builtin appraisal rule chain, but at the head
of the chain, as they are more restrictive than the secureboot policy
for root owned files.

Vivek, would this work?

thanks,

Mimi


