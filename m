Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaDXNBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:01:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbaDXNB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:01:28 -0400
Date: Thu, 24 Apr 2014 09:01:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Daniel J Walsh <dwalsh@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Simo Sorce <ssorce@redhat.com>,
        lpoetter@redhat.com, kay@redhat.com
Subject: Re: [PATCH 0/2] net: Implement SO_PEERCGROUP and SO_PASSCGROUP
 socket options
Message-ID: <20140424130122.GA19091@redhat.com>
References: <1397596546-10153-1-git-send-email-vgoyal@redhat.com>
 <20140422.160558.627080587952506099.davem@davemloft.net>
 <CALCETrWHA5ZmzOHnz9LO+7v4byc8QiynGyjE_ju5sjokNqrjZA@mail.gmail.com>
 <20140422.162927.2182797573155988911.davem@davemloft.net>
 <CALCETrX_TCbKy-3W590wG3rq9O3Hzbqc_wu3EGg7PKn2NNsTpQ@mail.gmail.com>
 <20140423190532.GE22755@redhat.com>
 <5358284B.7020706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5358284B.7020706@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 04:53:31PM -0400, Daniel J Walsh wrote:
> 
> On 04/23/2014 03:05 PM, Vivek Goyal wrote:
> > On Tue, Apr 22, 2014 at 01:31:13PM -0700, Andy Lutomirski wrote:
> > [..]
> >>> Otherwise, without SO_PASSCGROUP, there is no way for datagram sockets
> >>> to find out the peer's open() time cgroup.
> >> Right.
> >>
> >> I'd still like to know what userspace applications want this feature.
> >> The canonical example seems to be journald, but journald doesn't use
> >> unix datagram sockets AFAICS,
> > Dan Walsh mentiond that systemd also monitors /dev/log (datagram socket) and
> > logs everything in journal. There this information should be useful.
> >
> > Thanks
> > Vivek
> I am fine with collecting only the information available at "open".  I
> can potentially see other Userspace Resource Constraints being built
> based on the Cgroup the process is in.  For example openshift wants to 
> limit the amount of email a process can send to only a few per second,
> which might be able to be controlled by a relay listening on a
> particular socket. Then it could change the rules based on the
> Cgroup/Unit file the calling process was in. 

I suspect that we will see the need of both the kind of cgroup
information. One which shows current cgroup of sender and other which
shows cgroup of client when socket was opened. 

For the time being I will modify my patch as Dave Miller suggested and
repost. May be down the line there will be another option say
SO_PASSCURRENTCGROUP which will carry current cgroup of sender.

Thanks
Vivek
