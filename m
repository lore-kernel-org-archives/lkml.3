Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbbAVEf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:35:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:49608 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750796AbbAVEfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:35:25 -0500
Date: Wed, 21 Jan 2015 23:35:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150121233553.19d9ac5c@grimm.local.home>
In-Reply-To: <20150122042330.GU29656@ZenIV.linux.org.uk>
References: <20150121171953.823177070@goodmis.org>
	<20150121230007.GA10389@kroah.com>
	<20150122042330.GU29656@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 04:23:30 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> I would recommend against that - kernfs is overburdened by their need
> to accomodate cgroup weirdness.  IMO it's not a good model for
> anything, other than an anti-hard-drugs poster ("don't shoot that
> shit, or you might end up hallucinating _this_").

OK, I'm not the only one that thought kernfs seemed to go all over the
place. I guess I now know why. It was more of a hook for cgroups. I can
understand why cgroups needed it, as I found that creating files from a
mkdir and removing them with rmdir causes some pain in vfs with
handling of locking. As that's what I'm working on overcoming now.

But I think I solved my issues (testing it now), and hopefully by
tomorrow, I'll have a V2 out.

-- Steve
