Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbaDWUxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:53:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087AbaDWUxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:53:36 -0400
Message-ID: <5358284B.7020706@redhat.com>
Date: Wed, 23 Apr 2014 16:53:31 -0400
From: Daniel J Walsh <dwalsh@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@amacapital.net>
CC: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Simo Sorce <ssorce@redhat.com>,
        lpoetter@redhat.com, kay@redhat.com
Subject: Re: [PATCH 0/2] net: Implement SO_PEERCGROUP and SO_PASSCGROUP socket
 options
References: <1397596546-10153-1-git-send-email-vgoyal@redhat.com> <20140422.160558.627080587952506099.davem@davemloft.net> <CALCETrWHA5ZmzOHnz9LO+7v4byc8QiynGyjE_ju5sjokNqrjZA@mail.gmail.com> <20140422.162927.2182797573155988911.davem@davemloft.net> <CALCETrX_TCbKy-3W590wG3rq9O3Hzbqc_wu3EGg7PKn2NNsTpQ@mail.gmail.com> <20140423190532.GE22755@redhat.com>
In-Reply-To: <20140423190532.GE22755@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/23/2014 03:05 PM, Vivek Goyal wrote:
> On Tue, Apr 22, 2014 at 01:31:13PM -0700, Andy Lutomirski wrote:
> [..]
>>> Otherwise, without SO_PASSCGROUP, there is no way for datagram sockets
>>> to find out the peer's open() time cgroup.
>> Right.
>>
>> I'd still like to know what userspace applications want this feature.
>> The canonical example seems to be journald, but journald doesn't use
>> unix datagram sockets AFAICS,
> Dan Walsh mentiond that systemd also monitors /dev/log (datagram socket) and
> logs everything in journal. There this information should be useful.
>
> Thanks
> Vivek
I am fine with collecting only the information available at "open".  I
can potentially see other Userspace Resource Constraints being built
based on the Cgroup the process is in.  For example openshift wants to 
limit the amount of email a process can send to only a few per second,
which might be able to be controlled by a relay listening on a
particular socket. Then it could change the rules based on the
Cgroup/Unit file the calling process was in. 
