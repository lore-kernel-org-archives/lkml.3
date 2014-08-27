Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935209AbaH0P7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:59:09 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:57394 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934686AbaH0P7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:59:07 -0400
Date: Wed, 27 Aug 2014 09:58:44 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rabin Vincent <rabin@rab.in>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 3/8] cpufreq: kirkwood: Remove use of the clk provider
 API
Message-ID: <20140827155844.GA911@obsidianresearch.com>
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
 <1408375833-10703-4-git-send-email-tomeu.vizoso@collabora.com>
 <20140820225513.5251.284@quantum>
 <53F5A587.9030200@collabora.com>
 <20140821133825.GH8608@lunn.ch>
 <20140822192933.5251.53733@quantum>
 <20140822201112.GH17277@lunn.ch>
 <20140826214631.5251.66177@quantum>
 <20140826223637.GA5324@lunn.ch>
 <20140826233008.5251.50447@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826233008.5251.50447@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 04:30:08PM -0700, Mike Turquette wrote:

> 2) for the kexec-kernel-case, the responsibility is on the first kernel
> to set things up in a good state for the second kernel, with the
> exception of using kexec to debug/examime/recover from a kernel crash,
> in which case you likely don't care about this stuff as much

FWIW, we frequently use a kexec flow on Kirkwood for development here
- and I have not been able to get the initial kernel to cleanly shut
down before kexec'ing the second kernel.

The flow we've had to use involved including a pre-kernel stub in the
kexec flow that goes around and cleans up all the registers enough so
that the 2nd kernel will work properly. Critically it does things like
turn off ethernet DMA, because the initial kernel won't even do that
:|

There is some kind of support for doing this, but I ran out of time
unraveling the mess of config options to actually turn it on for
kirkwood.. It is tied to PM support which was/is missing elements on
Kirkwood..

Jason
