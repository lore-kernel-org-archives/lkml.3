Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3EIL3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:29:18 -0400
Received: from relay2.sgi.com ([192.48.179.30]:55905 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754037Ab3EIL3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:29:17 -0400
Date: Thu, 9 May 2013 06:29:16 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v8 11/11] Move arch/x86 reboot= handling to generic
 kernel.
Message-ID: <20130509112916.GU3672@sgi.com>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
 <1367937595-32241-12-git-send-email-holt@sgi.com>
 <20130508135029.ffbeefa6b8154bee31e7bbbe@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508135029.ffbeefa6b8154bee31e7bbbe@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 01:50:29PM -0700, Andrew Morton wrote:
> On Tue,  7 May 2013 09:39:55 -0500 Robin Holt <holt@sgi.com> wrote:
> 
> > Merge together the unicore32, arm, and x86 reboot= command line
> > parameter handling.
> > 
> > ...
> >
> > +static int __init reboot_setup(char *str)
> > +{
> > +	for (;;) {
> > +		/*
> > +		 * Having anything passed on the command line via
> > +		 * reboot= will cause us to disable DMI checking
> > +		 * below.
> > +		 */
> > +		reboot_default = 0;
> > +
> > +		switch (*str) {
> > +#if defined(CONFIG_X86) || defined(CONFIG_X86_64)
> > +		case 'w':
> > +			reboot_mode = REBOOT_WARM;
> > +			break;
> > +
> > +		case 'c':
> > +			reboot_mode = REBOOT_COLD;
> > +			break;
> > +
> > +#ifdef CONFIG_SMP
> > +		case 's':
> > +			if (isdigit(*(str+1))) {
> > +				reboot_cpu = (int) (*(str+1) - '0');
> > +				if (isdigit(*(str+2)))
> > +					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
> > +			}
> 
> Boy, that's some weird stuff.
> 
> What's wrong with doing
> 
> 			if (isdigit(str[1])) {
> 				reboot_cpu = str[1] - '0';
> 				if (isdigit(str[2]))
> 					reboot_cpu = reboot_cpu * 10 +
> 							str[2] - '0';
> 			}
> 
> ?
> 
> But it's still nonsense - we should eliminate its
> you-have-less-than-101-CPUs restriction by using, you know, atoi().

I had an earlier version which I must have dropped which handled the
larger parsing, but I do like your suggestion of using atoi.  I will
submit a -v9 in a few hours.

Robin
