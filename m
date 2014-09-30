Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaI3Rq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:46:58 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48645 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaI3Rq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:46:57 -0400
Date: Tue, 30 Sep 2014 18:46:55 +0100
From: Ross Lagerwall <rosslagerwall@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Mount propagation issue
Message-ID: <20140930174655.GB10601@hobo.lan>
References: <20140926233125.GA6918@hobo.lan>
 <87iok657jc.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87iok657jc.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 04:30:31PM -0700, Eric W. Biederman wrote:
> Ross Lagerwall <rosslagerwall@gmail.com> writes:
> > I hope someone has an idea of what's going on or how to debug this
> > because I've run out of ideas...
> 
> My guess is that some process (systemd?) is configured to unmount that
> directory if anything shows up mounted on it.  So when the mount
> propogates it gets unmounted and then the unmount propogates as well.
> 

Ah yes!  I'd forgotten that I previously had experimented with a mount
unit file for that directory and didn't realize that systemd would
actively prevent anything from being mounted at that point even if the
mount unit was inactive.

Turning up systemd's log level showed the following:
Sep 30 06:59:28 hobo systemd[279]: mnt-puppy.mount changed dead -> mounted
Sep 30 06:59:28 hobo systemd[1]: mnt-puppy.mount changed dead -> mounted
Sep 30 06:59:28 hobo systemd[1]: Unit mnt-puppy.mount is bound to inactive service. Stopping, too.
Sep 30 06:59:28 hobo systemd[1]: Trying to enqueue job mnt-puppy.mount/stop/fail
Sep 30 06:59:28 hobo systemd[1]: Installed new job mnt-puppy.mount/stop as 240
Sep 30 06:59:28 hobo systemd[1]: Enqueued job mnt-puppy.mount/stop as 240
Sep 30 06:59:28 hobo systemd[1]: Unmounting /mnt/puppy...
Sep 30 06:59:28 hobo systemd[1]: About to execute: /bin/umount -n /mnt/puppy

Thanks for pointing me in the right direction!
-- 
Ross Lagerwall
