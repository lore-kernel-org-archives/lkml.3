Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3FDRju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:39:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59376 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3FDRjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:39:49 -0400
Date: Tue, 4 Jun 2013 18:39:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] proc: avoid ->f_pos overflows in
 proc_task_readdir() paths
Message-ID: <20130604173917.GB13110@ZenIV.linux.org.uk>
References: <20130603190705.GA11517@redhat.com>
 <877giarg81.fsf@xmission.com>
 <20130604171435.GA20416@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604171435.GA20416@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 07:14:35PM +0200, Oleg Nesterov wrote:
> > There is another bug in here as well that we may return really crazy
> > things in the case of seek simultaneous with readdir.
> 
> i_mutex? both vfs_readdir() and default_llseek() take it... Anyway, this
> is another issue.

That's part of the reasons for the series I've mentioned (vfs.git#experimental);
seriously, check that up.
