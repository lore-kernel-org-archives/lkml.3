Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbaDPQOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:14:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbaDPQOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:14:03 -0400
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
From: Simo Sorce <ssorce@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Miller <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
In-Reply-To: <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
References: <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
	 <20140416002010.GA5035@redhat.com>
	 <CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
	 <20140416.085743.1614257692560892039.davem@davemloft.net>
	 <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Apr 2014 12:13:57 -0400
Message-ID: <1397664837.19767.410.camel@willson.li.ssimo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 07:37 -0700, Andy Lutomirski wrote:
> On Wed, Apr 16, 2014 at 5:57 AM, David Miller <davem@davemloft.net> wrote:
> >
> > Please, just stop.
> 
> No.
> 
> This thread is proposing an ABI.  This means that, if the ABI ends up
> in Linus's kernel, then it has to be supported forever.  Now is the
> time to find and fix any issues with it before they become much harder
> to fix.

Ok, but so far I haven't seen a single objection from you that has solid
grounds.

The only one that *may* be reasonable is the "secret" cgroup name one,
however nobody seem to come up with a reason why it is legitimate to
allow to keep cgroup names secret.

And if you can come up with such a good reason the SO_NOPASSCGROUP
option seem the right solution.

> This ABI is especially tricky because programs will use it even if
> they don't explicitly try to.  So just adding the ABI may break
> existing assumptions that are relevant to security or correctness.

It's not clear to me what you mean by this, either you explicitly use
SO_PASSCGROUP or not, it's not like you can involuntarily add a flag ...

Simo.


