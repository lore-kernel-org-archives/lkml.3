Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3KDWHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:07:08 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:65233 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3KDWHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:07:06 -0500
Date: Tue, 5 Nov 2013 07:06:59 +0900
From: Tejun Heo <tj@kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Victor Marmol <vmarmol@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        Rohit Jnagal <jnagal@google.com>
Subject: Re: [RFC PATCH 1/2] devices cgroup: allow can_attach() if ns_capable
Message-ID: <20131104220659.GB24165@mtj.dyndns.org>
References: <20130723181606.GA6342@sergelap>
 <20130723183018.GF21100@mtj.dyndns.org>
 <20130723183841.GA9021@tp>
 <CAOS58YPynQ-QBx5nZEnYrP5kGTVvv9VAj0cV0aYeikTitvTQbA@mail.gmail.com>
 <20130723190426.GA9577@tp>
 <20130723191245.GI21100@mtj.dyndns.org>
 <20130723192801.GA9923@tp>
 <CAOS58YPEKtEiZWsn-8u6OPr-UsyQp=XR+ecGmXyOdT0JnYAmsA@mail.gmail.com>
 <20131104215135.GA26190@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104215135.GA26190@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 04, 2013 at 09:51:35PM +0000, Serge E. Hallyn wrote:
> Do you have a list of such issues which you see with delegation?  That is,
> cases where, if ownership of a subtree is granted to a non-root user,
> that user can affect tasks owned by other users who are in other
> cgroups?

A lot of security is about logistics and cgroup simply doesn't have
them - depth, number of cgroups quota, even config changes or
subdirectory operations which involve RCU operations can easily be
used for DoS attacks.  Just think about how much complexity and effort
need to be spent on making and maintaining anything properly
delegatable to !priv users.  cgroup has never spent such design or
implementation effort - e.g. take a look at how event_control thing is
implemented, it's extremely easy to trigger OOM if you give that out
to !priv users.

cgroup has *never* been safe to give out to !priv users and it is
highly unlikely to be in any foreseeable future.  It will be a big new
giant feature which I frankly don't think is worth the risk or effort.
Think of it as giving out sysctl or firewall rule control to !priv
users.  Giving out subset of those controls do make sense in terms of
function but we don't do that and don't have infrastructure to support
such usage.  cgroup at this stage isn't that different.  If you insist
on doing that, you can but it is severely compromising in terms of
security and it'll stay that way for the foreseeable future.

Thanks.

-- 
tejun
