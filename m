Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaEMPSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:18:51 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:55383 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaEMPSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:18:37 -0400
Date: Tue, 13 May 2014 11:18:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] cgroup: update and fix parsing of
 "cgroup.subtree_control"
Message-ID: <20140513151833.GE23710@htj.dyndns.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
 <1399663975-315-5-git-send-email-tj@kernel.org>
 <537196D7.3020302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537196D7.3020302@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 11:51:51AM +0800, Li Zefan wrote:
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 35daf89..b81e7c0 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -2542,11 +2542,13 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
> >  	int ssid, ret;
> >  
> >  	/*
> > -	 * Parse input - white space separated list of subsystem names
> > -	 * prefixed with either + or -.
> > +	 * Parse input - space separated list of subsystem names prefixed
> > +	 * with either + or -.
> >  	 */
> >  	p = buffer;
> > -	while ((tok = strsep(&p, " \t\n"))) {
> > +	while ((tok = strsep(&p, " "))) {
> > +		if (tok[0] =='\0')
> 
> if (tok[0] == '\0')

Oops, updated.

Thanks.

-- 
tejun
