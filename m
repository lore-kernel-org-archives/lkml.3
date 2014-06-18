Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaFRSDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaFRSDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:03:48 -0400
Date: Wed, 18 Jun 2014 20:02:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Vasiliy Kulikov <segooon@gmail.com>,
        Gotou Yasunori <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] ns: introduce getnspid syscall
Message-ID: <20140618180237.GA22219@redhat.com>
References: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com> <53A030CE.6070101@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A030CE.6070101@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Pavel Emelyanov wrote:
>
> On 06/17/2014 02:21 PM, Chen Hanxiao wrote:
> > +	case PIDTYPE_PID:
> > +		ret = task_pid_nr_ns(task, ns2);
>
> But this is not correct. If task doesn't live in ns2, but ns2
> just has the ns->level small enough, then the wrong pid value
> would be reported.

Confused... pid_nr_ns() checks upid->ns == ns and returns zero
otherwise?

Oleg.

