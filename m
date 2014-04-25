Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaDYA3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:29:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbaDYA3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:29:47 -0400
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
From: Simo Sorce <ssorce@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: vgoyal@redhat.com, luto@amacapital.net, tj@kernel.org, dwalsh@redhat.com,
        linux-kernel@vger.kernel.org, lpoetter@redhat.com,
        cgroups@vger.kernel.org, kay@redhat.com, netdev@vger.kernel.org
In-Reply-To: <20140424.171155.806959282091051918.davem@davemloft.net>
References: <20140424203427.GC19091@redhat.com>
	 <20140424.164820.1543648508330465096.davem@davemloft.net>
	 <20140424210429.GD19091@redhat.com>
	 <20140424.171155.806959282091051918.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Apr 2014 20:29:41 -0400
Message-ID: <1398385781.2628.452.camel@willson.li.ssimo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 17:11 -0400, David Miller wrote:
> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Thu, 24 Apr 2014 17:04:29 -0400
> 
> > Does it really matter.
> 
> Good question, if it doesn't matter, you might as well log garbage.
> 
> There are a lot of logical holes in this discussion.
> 
> Real UIDs are always reported at sendmsg() time, not effective ones
> (the UID "at sendmsg() time").
> 
> Therefore if we were to add CGROUP passing at sendmsg() time it should
> report the "real cgroup", the one the task has at the time the file
> descriptor / socket was "created".

Given we are creating a new interface ... should we just send both the
cgroup at creation time and (optionally, if it differs) the cgroup the
process has at sendmsg() time, and let the peer sort out which one it is
interested in ?

Simo.

