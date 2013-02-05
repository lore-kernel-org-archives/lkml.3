Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab3BEJPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:15:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43177 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab3BEJPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:15:35 -0500
Date: Tue, 5 Feb 2013 10:15:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Message-ID: <20130205091532.GA4827@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
	Steve.Bannister@arm.com, Liviu.Dudau@arm.com
References: <20130204130403.GD13909@pd.tnic>
 <CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
 <20130204133648.GE13909@pd.tnic>
 <CAKohpo=aLnhM0Op_32ohWZK5eG5nT7iK0OktBe+8ygOQW7zUqQ@mail.gmail.com>
 <20130204140908.GC15452@pd.tnic>
 <CAKohpokowK6ybYd8aDUdfFYsnzoc5VAKsuPSkfxoDqJ3k+FwGA@mail.gmail.com>
 <20130204150511.GF13909@pd.tnic>
 <CAKohpokt0xtsj1eQDMw6JgvQVp4rgFyU-vUrtuuF+0jjOVNHRQ@mail.gmail.com>
 <20130204165057.GH13909@pd.tnic>
 <CAOh2x==fyfYwz+eXmPhBJTE+_q_fHyx2drXrM789XvCfEqPBUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOh2x==fyfYwz+eXmPhBJTE+_q_fHyx2drXrM789XvCfEqPBUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 12:50:31PM +0530, Viresh Kumar wrote:
> > I think this is cleaner but whatever - I don't care that much. My
> > only strong concern is that this thing should be a Kconfig option and
> > optional for arches where it doesn't apply.
> 
> Your concern is: we don't want to fix userspace for existing platforms
> where we have just a single cluster and so struct policy in the system.

No, as I said so many times already and you're unwilling to understand
it: multiple policies support in cpufreq should be optional and
selectable in Kconfig so that systems which don't need that, don't
have to see or use it. It is yet another feature which doesn't apply
universally so we make such features optional. Like the rest of the
gazillion things in the kernel already.

The existing sysfs layout cannot be changed because you're breaking
userspace and we don't do that. It is that simple.

Concerning adding new sysfs entries, I told you to make it as easy as
possible and as sensible as possible, dictated by the use cases. If you
can't come up with some, then talk to the people who are going to use
your design and ask them what makes sense the most.

*Then* write the code.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
