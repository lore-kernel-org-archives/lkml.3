Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaLQQW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:22:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaLQQW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:22:57 -0500
From: Thomas Renninger <trenn@suse.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Michal Privoznik <mprivozn@redhat.com>, rafael.j.wysocki@intel.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpupower: Correctly detect if running as root
Date: Wed, 17 Dec 2014 17:22:54 +0100
Message-ID: <12251128.9086t2JFoE@skinner>
User-Agent: KMail/4.14.2 (Linux/3.16.6-2-desktop; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1660884.y6rjWabQcf@vostro.rjw.lan>
References: <b03faaf6b63a9175da0ce7ab8e0fc3da0cba4a86.1418560562.git.mprivozn@redhat.com> <1660884.y6rjWabQcf@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 14, 2014 10:29:24 PM Rafael J. Wysocki wrote:
> On Sunday, December 14, 2014 01:36:52 PM Michal Privoznik wrote:
> > Some operations, like frequency-set, need root privileges. However,
> > the way that this is detected is not correct. The getuid() is called,
> > while in fact geteuid() should be. This way we can allow
> > distributions or users to set SETUID flags on the cpupower binary if
> > they want to and let regular users change the cpu frequency governor.
> > 
> > Signed-off-by: Michal Privoznik <mprivozn@redhat.com>
> 
> An ACK from Thomas is needed.
Patch is correct, Thanks!

Acked-by: Thomas Renninger <trenn@suse.de>

     Thomas
> 
> > ---
> > 
> >  tools/power/cpupower/utils/cpupower.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/power/cpupower/utils/cpupower.c
> > b/tools/power/cpupower/utils/cpupower.c index 7cdcf88..9ea9143 100644
> > --- a/tools/power/cpupower/utils/cpupower.c
> > +++ b/tools/power/cpupower/utils/cpupower.c
> > @@ -199,7 +199,7 @@ int main(int argc, const char *argv[])
> > 
> >  	}
> >  	
> >  	get_cpu_info(0, &cpupower_cpu_info);
> > 
> > -	run_as_root = !getuid();
> > +	run_as_root = !geteuid();
> > 
> >  	if (run_as_root) {
> >  	
> >  		ret = uname(&uts);
> >  		if (!ret && !strcmp(uts.machine, "x86_64") &&

