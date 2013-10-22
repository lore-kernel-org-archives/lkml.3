Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3JVTsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:48:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49684 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3JVTsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:48:39 -0400
Date: Tue, 22 Oct 2013 20:48:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, peterz@infradead.org
Subject: Re: [PATCH] add new prctl for a per process wide close on exec
Message-ID: <20131022194836.GZ13318@ZenIV.linux.org.uk>
References: <1382470038-1220-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382470038-1220-1-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 09:27:18PM +0200, Stefani Seibold wrote:

> This patch will increase security since no developers can review all libraries
> which there are using. Also in a team of developers it is not always possible
> to have a full survey over the code which is produced. Or the output of a code
> generators and so one. This patch allows a kind of preventive measures.
> 
> It can also prevent resource occupation. Imagine a long running process (a
> daemon) is execute from the application after open some file desciptors. For
> example libpcsclite.so will not open the socket with SOCK_CLOEXEC. Or a device
> driver which alows only a single open. In both cases the resource cannot
> reopened after a close. Sigh!
> 
> What do you think?

That it's a bad idea.  Not to mention anything else, the same unreviewed
libraries can get buggered if the program sets that "global close-on-exec"
and it's not at all obvious whether the breakage from that change will be less
or more dangerous than leaking opened files to children.

Al, fully expecting the Linux S-M crowd to jump on that one and come up with
yet another one-shot LSM... ;-/
