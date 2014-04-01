Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaDAPpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaDAPpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:45:51 -0400
Date: Tue, 1 Apr 2014 16:44:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] uprobes/x86: Introduce uprobe_xol_ops and
	arch_uprobe->ops
Message-ID: <20140401144447.GB18503@redhat.com>
References: <20140331194415.GA9307@redhat.com> <533A6221.2030805@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533A6221.2030805@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Masami Hiramatsu wrote:
>
> (2014/04/01 4:44), Oleg Nesterov wrote:
> > +
> > +static struct uprobe_xol_ops defaule_xop_ops = {
> > +	.pre_xol  = default_pre_xol_op,
> > +	.post_xol = default_post_xol_op,
>
> If there is no ops->emulate, I think it should not be defined now.
> You can add it when you really need it. :)

Yes, but the next patch will need it. I do not really mind, but if you
do not object I'd prefer to define it in this patch (note that it also
changes skip_sstep() to check ops->emulate even if it has no users yet).
This way the next change will be a little bit simpler.

In the longer term we will (probably) need ops->abort as well, but currently
we can assume handle_riprel_post_xol() in arch_uprobe_abort_xol() can do
nothing wrong even if ->ops != &defaule_xol_ops (one of the reasons for 3/7).

Oleg.

