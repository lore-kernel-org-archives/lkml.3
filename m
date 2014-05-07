Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaEGIqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:46:19 -0400
Received: from stringer.orebokech.com ([212.83.175.182]:39136 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaEGIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:46:15 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2014 04:46:15 EDT
From: Romain Francoise <romain@orebokech.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "cpufreq\@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Performance regression in v3.14
Organization: orebokech dot com
References: <20140506163559.GA5308@localhost>
	<CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com>
	<20140507073536.GA1973@localhost>
Date: Wed, 07 May 2014 10:36:51 +0200
In-Reply-To: <20140507073536.GA1973@localhost> (Johan Hovold's message of
	"Wed, 7 May 2014 09:35:36 +0200")
Message-ID: <87tx92rnmk.fsf@kima.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan Hovold <jhovold@gmail.com> writes:

> So I guess that idle-active difference is normal for acpi-cpufreq and
> that the problem only arises in or with the intel_pstate driver.

I've also noticed some performance issues with intel_pstate in powersave
mode, in my case playing fullscreen video was very choppy. Switching to
the performance governor fixed things as well. Looking at turbostat, the
cores remain close to their minimal frequency pretty much all the time
in powersave.

Maybe 91a4cd4f3d8169d ("intel_pstate: Remove periodic P state boost")
which went in v3.14 is the culprit?

(I would also be curious to know what the driver authors recommend for
typical laptop usage, performance or powersave, since it defaults to
performance.)
