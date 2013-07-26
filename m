Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab3GZPT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:19:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab3GZPT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:19:56 -0400
Date: Fri, 26 Jul 2013 17:14:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] debugfs: debugfs_remove_recursive() must not rely
	on list_empty(d_subdirs)
Message-ID: <20130726151432.GD19472@redhat.com>
References: <20130723205854.GA9036@redhat.com> <20130724184640.GA21322@redhat.com> <20130725192742.GA14060@redhat.com> <20130725200423.GA22274@redhat.com> <20130725234357.GA14958@kroah.com> <20130726151151.GA19472@redhat.com> <20130726151224.GB19472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726151224.GB19472@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh, sorry for noise.

Please ignore the extra email with the wrong subject.

On 07/26, Oleg Nesterov wrote:
>
> debugfs_remove_recursive() is wrong,
> 
> 1. it wrongly assumes that !list_empty(d_subdirs) means that this
>    dir should be removed.
> 
>    This is not that bad by itself, but:
> 
> 2. if d_subdirs does not becomes empty after __debugfs_remove()
>    it gives up and silently fails, it doesn't even try to remove
>    other entries.
> 
>    However ->d_subdirs can be non-empty because it still has the
>    already deleted !debugfs_positive() entries.
> 

