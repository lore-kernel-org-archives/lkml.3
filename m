Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3FFWrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:47:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36281 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3FFWrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:47:23 -0400
Date: Thu, 6 Jun 2013 17:47:10 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com,
        davem@davemloft.net
Subject: Re: [PATCH RFC 00/48] Add namespace support for audit
Message-ID: <20130606224710.GA30502@tp>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
 <519B3B4E.1070405@cn.fujitsu.com>
 <20130606215255.GA28978@tp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606215255.GA28978@tp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge Hallyn (serge.hallyn@ubuntu.com):
> Quoting Gao feng (gaofeng@cn.fujitsu.com):
> > On 05/07/2013 10:20 AM, Gao feng wrote:
> > > This patchset try to add namespace support for audit.
> > > 
> > > I choose to assign audit to the user namespace.
> > > Right now,there are six kinds of namespaces, such as
> > > net, mount, ipc, pid, uts and user. the first five
> > > namespaces have special usage. the audit isn't suitable to
> > > belong to these five namespaces, so the user namespace
> > > may be the best choice.
> > > 
> > > Through I decide to make audit related resources per user
> > > namespace, but audit uses netlink to communicate between kernel
> > > space and user space, and the netlink is a private resource
> > > of per net namespace. So we need the capability to allow the
> > > netlink sockets to communicate with each other in the same user
> > > namespace even they are in different net namespace. [PATCH 2/48]
> > > does this job, it adds a new function "compare" for per netlink
> > > table to compare two sockets. it means the netlink protocols can
> > > has its own compare fuction, For other protocols, two netlink
> > > sockets are different if they belong to the different net namespace.
> > > For audit protocol, two sockets can be the same even they in different
> > > net namespace,we use user namespace not net namespace to make the
> > > decision.
> > > 
> > > There is one point that some people may dislike,in [PATCH 1/48],
> > > the kernel side audit netlink socket is created only when we create
> > > the first netns for the userns, and this userns will hold the netns
> > > until we destroy this userns.
> > > 
> > > The other patches just make the audit related resources per
> > > user namespace.
> > > 
> > > This patchset is sent as an RFC,any comments are welcome.
> 
> Hi,
> 
> thanks for sending this.  I think you need to ping the selinux folks
> for comment though.  It appears to me that, after this patchset, the
> kernel with CONFIG_USER_NS=y could not be LSPP-compliant, because
> the selinux-generated audit messages do not always go to init_user_ns.
> 
> Additionally, the only type of namespacing selinux wants is where it
> is enforced by policy compiler and installer using typenames - i.e.
> 'container1.user_t' vs 'user_t'.  Selinux does not want user namespaces
> to affect selinux enforcement at all.  (at least last I knew, several
> years ago at a mini-summit, I believe this was from Stephen Smalley).

That sort of sounds like I'm distancing myself from that, which I
don't mean to do.  I agree with the decison:  MAC (selinux, apparmor
and smack) should not be confuddled by user namespaces.  (posix caps
are, as always, a bit different).

> I think it's good to have userspace-generated audit messages (i.e.
> auditctl -m 'hi there') sent to the same user namespace.  But the
> selinux messages, near as I can tell, need to all go to init_user_ns.
> 
> thanks,
> -serge
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
