Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919Ab3DIVMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:12:00 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:39068 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934864Ab3DIVL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:11:58 -0400
Date: Tue, 9 Apr 2013 14:11:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, jpoimboe@redhat.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter@redhat.com,
        workman-devel@redhat.com, dhaval.giani@gmail.com,
        cgroups@vger.kernel.org
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130409211152.GO6186@mtj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <20130409095024.GI25576@redhat.com>
 <20130409193851.GJ6186@mtj.dyndns.org>
 <20130409194640.GK6186@mtj.dyndns.org>
 <20130409210422.GA31120@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409210422.GA31120@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Serge.

On Tue, Apr 09, 2013 at 04:04:22PM -0500, Serge Hallyn wrote:
> So for instance if there is a dbus call saying "please create cgroup
> /x with (some constraints) and put $$ into it", "something" in the
> container can convert that into "please create cgroup /lxc/c1/x
> and put (host_uid($$)) into it" and pass that to the host's (or
> parent container's) "something".

Yeap, definitely.  It shouldn't be difficult to make it transparent to
individual consumers.  It would actually be far easier to achieve that
with userland agent which knows what's going on in the middle.

> So perhaps it is best if the container monitor, living in the parent
> namespaces, opens a socket '@cgroup_monitor' in the container
> namespace (through setns), listens for container-userpsace requests
> there, and passes them on to the host's monitor (which hopefully
> also listens on '@cgroup_monitor', @ being '\0').  Note that my
> mentino of converting pids requires a new kernel feature which we
> don't currently have (but have wanted for a long time).

Yeah, details may change but in principle something like that.

Thanks.

-- 
tejun
