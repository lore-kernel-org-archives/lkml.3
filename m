Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3FFOhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:37:53 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:56232 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3FFOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:37:52 -0400
Date: Thu, 6 Jun 2013 16:37:50 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Strange intermittent EIO error when writing to stdout since
 v3.8.0
Message-ID: <20130606143750.GB520@x4>
References: <20130606115417.GA520@x4>
 <51B09A26.3080603@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B09A26.3080603@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.06.06 at 10:18 -0400, Peter Hurley wrote:
> On 06/06/2013 07:54 AM, Markus Trippelsdorf wrote:
> > Since v3.8.0 several people reported intermittent IO errors that happen
> > during high system load while using "emerge" under Gentoo:
> > ...
> >    File "/usr/lib64/portage/pym/portage/util/_eventloop/EventLoop.py", line 260, in iteration
> >      if not x.callback(f, event, *x.args):
> >    File "/usr/lib64/portage/pym/portage/util/_async/PipeLogger.py", line 99, in _output_handler
> >      stdout_buf[os.write(stdout_fd, stdout_buf):]
> >    File "/usr/lib64/portage/pym/portage/__init__.py", line 246, in __call__
> >      rval = self._func(*wrapped_args, **wrapped_kwargs)
> > OSError: [Errno 5] Input/output error
> 
> Looks to me like a user-space bug: EIO is returned when the other
> end of the "pipe" has been closed.
> 
> FWIW, I didn't see where the OP tried to revert
>     'SpawnProcess: stdout_fd FD_CLOEXEC'
> 
> The only non-emerge related comment (#21 in the link provided) refers to
>    'a similar issue sometimes happened when I built Firefox by hand [..snip..]
>     And it would randomly crash during the build.
> 
>     Since I've recompiled Python with gcc-4.6 this issue also never occurred
>     again.'
> 
> That comment doesn't really corroborate the reported bug.

That comment was from me (I use 'octoploid' for blog trolling, etc.) and
is wrong. The Firefox build issue happend again today. See also the rest
of my mail:

> (A similar issue also happens when building Firefox since v3.8.0. But
> because Firefox's build process doesn't raise an exception it just
> dies at random points without giving a clue.)

Please note that both the Firefox build process and Portage (emerge)
are implemented in Python.

-- 
Markus
