Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbbAHTjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:39:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbbAHTjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:39:51 -0500
From: Paul Moore <pmoore@redhat.com>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Stephen Smalley <sds@epoch.ncsc.mil>,
        James Morris <james.l.morris@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, selinux@tycho.nsa.gov
Subject: Re: noisy selinux messages on tmpfs mount.
Date: Thu, 08 Jan 2015 14:39:42 -0500
Message-ID: <2354586.80TRdrKbtf@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <3227891.DhTeT4XeAv@sifl>
References: <20150108190822.GB4365@codemonkey.org.uk> <3227891.DhTeT4XeAv@sifl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 08, 2015 02:34:57 PM Paul Moore wrote:
> On Thursday, January 08, 2015 02:08:22 PM Dave Jones wrote:
> > systemd has started mounting a tmpfs in /run/user/<uid> every time a
> > session begins.  So after ssh'ing into a box a number of times, dmesg
> > looks like this..
> > 
> > [...] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> > [...] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> 
> {snip}
> 
> > What's a good solution to stopping this spew ? printk_once doesn't seem
> > like a good fit, in case someone is doing different labelling behaviours
> > between mounts.
> > 
> > Could we only print it if the mount is being done with non-default
> > behaviour perhaps?
> 
> I'm very curious to hear Stephen's opinion on the issue, but I wonder how
> much this would honestly impact us if we removed this message in the case
> where we mount the filesystem with a known labeling behavior.

[NOTE: adding the SELinux list to the CC line.]

-- 
paul moore
security @ redhat

