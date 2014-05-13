Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbaEMO2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:28:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759892AbaEMO2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:28:35 -0400
Date: Tue, 13 May 2014 10:28:22 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, arozansk@redhat.com,
        serge@hallyn.com, ebiederm@xmission.com, sgrubb@redhat.com
Subject: Re: [PATCH V2 2/6] audit: log namespace serial numbers
Message-ID: <20140513142822.GC27560@madcap2.tricolour.ca>
References: <cover.1399681022.git.rgb@redhat.com>
 <e1b3ea66770e9e8d067c4fb725a6940c41ccf2f2.1399681022.git.rgb@redhat.com>
 <1399737362.3558.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399737362.3558.22.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/10, Eric Paris wrote:
> On Fri, 2014-05-09 at 20:27 -0400, Richard Guy Briggs wrote:
> 
> Not so relevant because you delete all of this code later...  But
> still...
> 
> > +#ifdef CONFIG_NAMESPACES
> > +void audit_log_namespace_info(struct audit_buffer *ab, struct task_struct *tsk)
> > +{
> > +	struct nsproxy *nsproxy;
> > +
> > +	rcu_read_lock();
> 
> ok, so we are under rcu_read_lock() and cannot sleep
> 
> > +	nsproxy = task_nsproxy(tsk);
> > +	if (nsproxy != NULL) {
> > +		audit_log_format(ab, " mntns=%llx", nsproxy->mnt_ns->serial_num);
> 
> But this could do an allocation, are we sure that everything used
> GFP_ATOMIC when creating the audit buffer? [hint: it doesn't]

Ugh, missed that.  Even more reason to go with the ns_entries export.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
