Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbaFJUTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:19:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbaFJUTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:19:14 -0400
Date: Tue, 10 Jun 2014 13:23:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] debugfs: Fix corrupted loop in
 debugfs_remove_recursive
Message-ID: <20140610202302.GB20499@kroah.com>
References: <20140609140607.3e3aae39@gandalf.local.home>
 <20140610093357.7ef3792b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610093357.7ef3792b@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 09:33:57AM -0400, Steven Rostedt wrote:
> On Mon, 9 Jun 2014 14:06:07 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > [ I'm currently running my tests on it now, and so far, after a few
> >  hours it has yet to blow up. I'll run it for 24 hours which it never
> >  succeeded in the past. ]
> 
> I ran with this patch on three boxes all night, one for 24 hours. No
> problems. I stopped the tests, removed the patch, ran the test on the
> same boxes and they all crashed within an hour.
> 
> This patch definitely fixes the bug.
> 
> The test I ran was:
> 
> while :; do
>  ./ftrace-test-mkinstances || break
>  ./ftrace-test-mkinstances-2 || break
> done
> 
> Note, the tests expect debugfs to be mounted at /debug.

Well, those are some broken tests :)

Anyway, thanks for the patch, I'll queue it up after 3.16-rc1 is out.

greg k-h
