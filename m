Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaHFScJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:32:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbaHFScH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:32:07 -0400
Date: Wed, 6 Aug 2014 18:32:00 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [REVIEW][PATCH 2/4] proc: Implement /proc/thread-self to point
 at the directory of the current thread
Message-ID: <20140806183200.GQ14872@ubuntumail>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
 <87bns5cakh.fsf@x220.int.ebiederm.org>
 <20140806143500.GA23127@mail.hallyn.com>
 <871tsttr4u.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871tsttr4u.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> > Hi Eric,
> >
> > I've not had a chance to test these, but apart from two trivial
> > comments below these look good to me, and I appreciate the feature.
> > So with the two fixes (if needed),
> >
> > Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> 
> >> +static int proc_thread_self_readlink(struct dentry *dentry, char __user *buffer,
> >> +			      int buflen)
> >> +{
> >> +	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
> >> +	pid_t tgid = task_tgid_nr_ns(current, ns);
> >> +	pid_t pid = task_pid_nr_ns(current, ns);
> >> +	char tmp[PROC_NUMBUF + 6 + PROC_NUMBUF];
> >
> > In the extreme case you're not adding space for a \0 ?  (Unless
> > PROC_NUMBUF includes that)
> 
> PROC_NUMBUF has enough space for a sign for the maximum of 10 digits
> for a newline and a terminating \0.  So yes PROC_NUMBUF includes the
> space for a terminating \0.

Ah, I see it's 13.  Sounds good then, thanks.
