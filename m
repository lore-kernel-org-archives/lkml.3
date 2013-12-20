Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab3LTBkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:40:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab3LTBkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:40:16 -0500
Date: Thu, 19 Dec 2013 20:40:07 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: fix build error when disable audit
Message-ID: <20131220014007.GD14944@madcap2.tricolour.ca>
References: <1387420469-27665-1-git-send-email-gaofeng@cn.fujitsu.com>
 <52B25CA8.8090806@cn.fujitsu.com>
 <20131220011956.GA14944@madcap2.tricolour.ca>
 <52B39FEB.8030308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52B39FEB.8030308@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/20, Gao feng wrote:
> On 12/20/2013 09:19 AM, Richard Guy Briggs wrote:
> > On 13/12/19, Gao feng wrote:
> >> On 12/19/2013 10:34 AM, Gao feng wrote:
> >>> kernel/capability.c: In function ‘SYSC_capset’:
> >>> kernel/capability.c:280:2: warning: passing argument 1 of ‘audit_log_capset’ makes integer from pointer without a cast [enabled by default]
> >>>   audit_log_capset(new, current_cred());
> >>>   ^
> >>> In file included from kernel/capability.c:10:0:
> >>> include/linux/audit.h:400:20: note: expected ‘pid_t’ but argument is of type ‘struct cred *’
> >>>  static inline void audit_log_capset(pid_t pid, const struct cred *new,
> >>>                     ^
> >>> kernel/capability.c:280:2: error: too few arguments to function ‘audit_log_capset’
> >>>   audit_log_capset(new, current_cred());
> >>>   ^
> >>> In file included from kernel/capability.c:10:0:
> >>> include/linux/audit.h:400:20: note: declared here
> >>>  static inline void audit_log_capset(pid_t pid, const struct cred *new,
> >>>                     ^
> >>> make[1]: *** [kernel/capability.o] Error 1
> >>
> >> BTW, bug introduced by commmit 26b81eb408c411d86c7cc93278fb88fbcd785f65
> >> audit: Simplify and correct audit_log_capset
> > 
> > Yup, found it.  Thanks for the patch.  Since it isn't upstream yet, I
> > may merge it and rebase for linux-next.
> 
> thank you Richard, btw, do you have plan to push these changes to the linux-next?

Yes, that's where I'm putting all these, via Eric.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
