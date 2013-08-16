Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3HPPTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab3HPPTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:19:33 -0400
Date: Fri, 16 Aug 2013 17:13:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jaromir Capik <jcapik@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ania Honess <ahoness@redhat.com>, atomlin@redhat.com,
        asolanas@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: proc/stat: idle goes backward
Message-ID: <20130816151339.GA29675@redhat.com>
References: <v5wUE000000000000000000000000000000000000000000000MRITO500uRRuI-89T-iqXCkOVGWF4w@sfdc.net> <1904614521.2884383.1376487067689.JavaMail.root@redhat.com> <1277145964.2082352.1376490809716.JavaMail.root@redhat.com> <20130816144704.GA25904@redhat.com> <20130816150122.GB24210@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816150122.GB24210@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Frederic Weisbecker wrote:
>
> On Fri, Aug 16, 2013 at 04:47:04PM +0200, Oleg Nesterov wrote:
> >
> > Questions:
> >
> > 	- Any other reason why it can be non-monotonic?
> >
> > 	- Should we fix this or should we document that userspace
> > 	  should handle this itself?
> >
> > 	  IOW, is this is bug or not?
>
> I don't know if we want to fix it (I personally think we should because it is not the
> first time I hear complains about this) but if we do, here is a possible fix:
>
> https://lkml.org/lkml/2013/8/8/638

Thanks! it is not easy to read the patches on lkml.org and I do
not understand this code enough. But it seems that this should
address my concerns, including the "even ignoring drivers/cpuidle/".

Except, I am not sure that these changes handle the case when
nr_iowait() change in between.

Are you going to resend?

Oleg.

