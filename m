Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab3FNI5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:57:21 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:49445 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3FNI5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:57:19 -0400
Date: Fri, 14 Jun 2013 10:57:12 +0200
From: Robert Richter <rric@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/14] perf, persistent: Exposing persistent events
 using sysfs
Message-ID: <20130614085712.GU12218@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-14-git-send-email-rric@kernel.org>
 <87a9mt2zcf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9mt2zcf.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.06.13 11:36:00, Namhyung Kim wrote:
> > +static int pers_event_sysfs_register(struct pers_event *event)
> > +{
> > +	struct device_attribute *attr = &event->sysfs.attr;
> > +	int idx;
> > +
> > +	*attr = (struct device_attribute)__ATTR(, 0444, pers_event_sysfs_show,
> > +						NULL);
> > +	attr->attr.name = event->name;
> 
> When I added another persistent event with this API, I got an WARNING
> from lockdep like this:
> 
> [    0.432506] BUG: key ffff88040946f140 not in .data!
> [    0.432581] ------------[ cut here ]------------
> [    0.432656] WARNING: at /home/namhyung/project/linux/kernel/lockdep.c:2987 lockdep_init_map+0x53d/0x570()
> [    0.432763] DEBUG_LOCKS_WARN_ON(1)
> 
> 
> I guess we need the following line here:
> 
> 	sysfs_attr_init(&attr->attr);

Yes, added your change. Thanks Namhyung for reviewing and testing.

-Robert
