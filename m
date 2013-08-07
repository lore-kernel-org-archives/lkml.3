Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab3HGNsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:48:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab3HGNsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:48:35 -0400
Date: Wed, 7 Aug 2013 08:48:23 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rui Xiang <rui.xiang@huawei.com>, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        libo.chen@huawei.com, netfilter-devel@vger.kernel.org,
        guz.fnst@cn.fujitsu.com, akpm@linux-foundation.org
Subject: Re: [PATCH v3 00/11] Add namespace support for syslog
Message-ID: <20130807134823.GA3702@sergelap>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
 <878v0evssv.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v0evssv.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> Since this still has not been addressed.  I am going to repeat Andrews
> objection again.
> 
> Isn't there a better way to get iptables information out than to use
> syslog.  I did not have time to follow up on that but it did appear that

Bruno suggested NFLOG target + ulogd.  That's not ideal, but doable.  At
least each container should be able to do that for itself.  What it
won't do is let a host admin make sure that he doesn't get corrupted
syslog entries when partial-lines get sent from several containers and
the kernel and randomly spliced together.  It also would simply be
better if the information was *always* sent to userspace instead of
syslog.

> someone did have a better way to get the information out.
> 
> Essentially the argument against this goes.  The kernel logging facility
> is really not a particularly good tool to be using for anything other
> than kernel debugging information, and there appear to be no substantial
> uses for a separate syslog that should not be done in other ways.
> 
> That design objection must be addressed before merging this code can be
> given serious consideration.
> 
> Eric
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
