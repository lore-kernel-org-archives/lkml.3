Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbaDXM1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:27:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbaDXM1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:27:47 -0400
Date: Thu, 24 Apr 2014 14:27:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] uprobes/tracing: uprobe_perf_open() forgets to
	handle the error from uprobe_apply()
Message-ID: <20140424122721.GA9988@redhat.com>
References: <20140423165808.GA29485@redhat.com> <20140423165830.GA29493@redhat.com> <20140424090341.GA6437@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424090341.GA6437@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24, Srikar Dronamraju wrote:
>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks, included!

> > +		tu->filter.nr_systemwide--;
> >  		done = tu->filter.nr_systemwide;
> > -		tu->filter.nr_systemwide++;
> >  	}
>
> Nit: I think 2 lines can be made into
>  done = --tu->filter.nr_systemwide;
...
> > -		tu->filter.nr_systemwide--;
> >  		done = tu->filter.nr_systemwide;
> > +		tu->filter.nr_systemwide++;
> >  	}
>
> Nit: Similarly lines can be made into
>  done = tu->filter.nr_systemwide++;

Yes, perhaps, but this has nothing to do with this patch, it does not
change this code.

And can't resist... you know, initially I wrote this code this way, but
then I decided to make it more straightforward to avoid the potential nits
from reviewers ;)

Oleg.

