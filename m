Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaDOXJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaDOXJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:09:07 -0400
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
From: Simo Sorce <ssorce@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        lpoetter@redhat.com, kay@redhat.com, dwalsh@redhat.com
In-Reply-To: <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
References: <1397596546-10153-1-git-send-email-vgoyal@redhat.com>
	 <1397596546-10153-3-git-send-email-vgoyal@redhat.com>
	 <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Apr 2014 19:09:00 -0400
Message-ID: <1397603340.19767.362.camel@willson.li.ssimo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 14:53 -0700, Andy Lutomirski wrote:
> On Tue, Apr 15, 2014 at 2:15 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > This patch implements socket option SO_PASSCGROUP along the lines of
> > SO_PASSCRED.
> >
> > If SO_PASSCGROUP is set, then recvmsg() will get a control message
> > SCM_CGROUP which will contain the cgroup path of sender. This cgroup
> > belongs to first mounted hierarchy in the sytem.
> >
> > SCM_CGROUP control message can only be received and sender can not send
> > a SCM_CGROUP message. Kernel automatically generates one if receiver
> > chooses to receive one.
> >
> > This works both for unix stream and datagram sockets.
> >
> > cgroup information is passed only if either the sender or receiver has
> > SO_PASSCGROUP option set. This means for existing workloads they should
> > not see any significant performance impact of this change.
> 
> This is odd.  Shouldn't an SCM_CGROUP cmsg be generated when the
> receiver has SO_PASSCGROUP set and the sender passes SCM_CGROUP to
> sendmsg?

What would be the point ?

Simo.


