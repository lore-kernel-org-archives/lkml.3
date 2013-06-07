Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3FGQHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:07:11 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:35776 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab3FGQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:07:07 -0400
Date: Fri, 7 Jun 2013 18:07:04 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Mikael Pettersson <mikpe@it.uu.se>,
        David Howells <dhowells@redhat.com>
Subject: Re: Strange intermittent EIO error when writing to stdout since
 v3.8.0
Message-ID: <20130607160704.GB6854@x4>
References: <20130606115417.GA520@x4>
 <51B09A26.3080603@hurleysoftware.com>
 <20130606143750.GB520@x4>
 <51B1FEB1.8040103@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B1FEB1.8040103@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.06.07 at 11:39 -0400, Peter Hurley wrote:
> On 06/06/2013 10:37 AM, Markus Trippelsdorf wrote:
> > On 2013.06.06 at 10:18 -0400, Peter Hurley wrote:
> >> On 06/06/2013 07:54 AM, Markus Trippelsdorf wrote:
> >>> Since v3.8.0 several people reported intermittent IO errors that happen
> >>> during high system load while using "emerge" under Gentoo:
> >>> ...
> >>>     File "/usr/lib64/portage/pym/portage/util/_eventloop/EventLoop.py", line 260, in iteration
> >>>       if not x.callback(f, event, *x.args):
> >>>     File "/usr/lib64/portage/pym/portage/util/_async/PipeLogger.py", line 99, in _output_handler
> >>>       stdout_buf[os.write(stdout_fd, stdout_buf):]
> >>>     File "/usr/lib64/portage/pym/portage/__init__.py", line 246, in __call__
> >>>       rval = self._func(*wrapped_args, **wrapped_kwargs)
> >>> OSError: [Errno 5] Input/output error
> 
> Based on the other reports from Mikael and David, I suspect this problem
> may have to do with my commit 699390354da6c258b65bf8fa79cfd5feaede50b6:
> 
>    pty: Ignore slave pty close() if never successfully opened
> 
> This commit poisons the pty under certain error conditions that may
> occur from parallel open()s (or parallel close() with pending write()).
> 
> It's unclear to me which error condition is triggered and how user-space
> got an open file descriptor but that seems the most likely. Is the problem
> reproducible enough that a debug patch would likely trigger?

A debug patch would be appreciated.
In my case the problem occurs very irregularly; sometimes it happens a
few times per day, at other times I don't see the bug for three weeks.

But if Mikael and David could also run their kernels with the debug
patch applied, hopefully that's enough to trigger the issue more regularly.

-- 
Markus
