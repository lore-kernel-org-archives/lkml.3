Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbaKYPPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:15:23 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56443 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKYPPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:15:20 -0500
Date: Tue, 25 Nov 2014 15:15:16 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org
Subject: Re: [PATCH] of: support passing console options with stdout-path
Message-ID: <20141125151515.GG2361@bivouac.eciton.net>
References: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
 <20141125145854.A46EDC44343@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125145854.A46EDC44343@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 02:58:54PM +0000, Grant Likely wrote:
> > +		len = strchrnul(path, ':') - path;
> > +
> >  		for_each_property_of_node(of_aliases, pp) {
> >  			if (strlen(pp->name) == len && !strncmp(pp->name, path, len)) {
> >  				np = of_find_node_by_path(pp->value);
> 
> Can you add a testcase to drivers/of/unittests.c for this new path
> parsing? Then we know it's correct!

Will do.
 
> > @@ -1830,8 +1835,12 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
> >  			name = of_get_property(of_chosen, "linux,stdout-path", NULL);
> >  		if (IS_ENABLED(CONFIG_PPC) && !name)
> >  			name = of_get_property(of_aliases, "stdout", NULL);
> > -		if (name)
> > +		if (name) {
> >  			of_stdout = of_find_node_by_path(name);
> > +			of_stdout_options = strchr(name, ':');
> > +			if (of_stdout_options != NULL)
> > +				of_stdout_options++;
> > +		}
> 
> Not so good. The ':' should actually be a generic part of
> of_find_node_by_path(), it doesn't have to be limited to stdout parsing.
> There are other places that would use it. I would add a second,
> optional, argument to of_find_node_by_path() that will update a pointer
> to the arguments after the ':'.

So, I agree this would be nicer...

However, I'm counting 157 callers of this function outside of
drivers/of and 43 inside. Any chance you'd let me get away with a
separate of_find_extra_options_by_path()?

/
    Leif
