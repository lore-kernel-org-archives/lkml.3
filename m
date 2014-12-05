Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaLEWHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:07:11 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58666 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751239AbaLEWHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:07:09 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linda Knippers <linda.knippers@hp.com>
Cc: Ethan Zhao <ethan.zhao@oracle.com>, dirk.j.brandewie@intel.com,
        kristen@linux.intel.com, viresh.kumar@linaro.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com,
        alexey.kodanev@oracle.com
Subject: Re: [PATCH 2/2 V8] intel_pstate: add kernel parameter to force loading.
Date: Fri, 05 Dec 2014 23:28:33 +0100
Message-ID: <1450362.V0bfHnJ0NE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5481D8B9.2030603@hp.com>
References: <1417772453-22483-1-git-send-email-ethan.zhao@oracle.com> <5481D8B9.2030603@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 05, 2014 11:09:29 AM Linda Knippers wrote:
> On 12/5/2014 4:40 AM, Ethan Zhao wrote:
> > To force loading on Oracle Sun X86 servers, provide one kernel command line
> > parameter
> > 
> >   intel_pstate = force
> > 
> > For those who be aware of the risk of no power capping capabily working and
> > try to get better performance with this driver.
> > 
> > Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> > Tested-by: Alexey Kodanev <alexey.kodanev@oracle.com>
> > ---
> >  v2: change to hardware vendor specific naming parameter.
> >  v4: refine code and doc.
> >  v5&v6: fix a typo in doc.
> >  v7: change enum PCC to PPC.
> >  v8: change the name of kernel command line parameter to generic one.
> > 
> >  Documentation/kernel-parameters.txt | 5 +++++
> >  drivers/cpufreq/intel_pstate.c      | 6 +++++-
> >  2 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 479f332..7d0983e 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -1446,6 +1446,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  		       disable
> >  		         Do not enable intel_pstate as the default
> >  		         scaling driver for the supported processors
> > +		       force
> > +			 Enable intel_pstate on systems where it may cause problems to
> > +			 happen due to conflicts with platform firmware attempting to
> > +			 drive P-states by itself in certain situations (for thermal 
> > +			 control or power capping in general or other purposes).
> 
> I suggest something like:
> 			Enable intel_pstate on systems that prohibit it by
> 			default in favor of acpi-cpufreq.  Forcing the
> 			intel_pstate driver instead of acpi-cpufreq may disable
> 			platform features, such as thermal controls and power
> 			capping, that rely on ACPI p-state information being
> 			used by the OS and therefore should be used with care.
> 			This option does not work with processors that aren't
> 			supported by the intel_pstate driver or on platforms
> 			that use pcc-cpufreq instead of acpi-cpufreq.
> 
> Maybe this is too specific but I believe it is accurate.  Comments?

Looks good to me, thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
