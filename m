Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762377Ab3DCQxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:53:31 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:2563 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761939Ab3DCQx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:53:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKOUX1-01-2TO-02
X-M-MSG: 
Date: Wed, 3 Apr 2013 11:53:24 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, Thomas Renninger <trenn@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V3 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130403165324.GB17919@jshin-Toonie>
References: <1364926304-1799-1-git-send-email-jacob.shin@amd.com>
 <20130402192352.GC17675@pd.tnic>
 <20130402200337.GA17919@jshin-Toonie>
 <2932884.BNCEuERbdR@skinner.arch.suse.de>
 <20130402210124.GI17675@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130402210124.GI17675@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 11:01:24PM +0200, Borislav Petkov wrote:
> On Tue, Apr 02, 2013 at 10:51:51PM +0200, Thomas Renninger wrote:
> > powersave_bias is undocumented in Documentation/cpu-freq/...
> > I guess its use-case is for people who want to get some percent more
> > power savings out of their laptop and do not care of the one or other
> > percent performance.
> > In fact I would like to get rid of this extra code and I expect nobody would 
> > miss it.
> > I might miss a configuration tool where someone went through the code,
> > documented things and allows users to set powersave_bias values through
> > some /etc/* config files.
> > Yep, if you want anyone to make use of this, it should better get
> > embedded in more general, at least general ondemand code.
> 
> Yeah, it all sounds like we want to enable this by default on systems
> which support it. Maybe with an off-switch for people who want plain
> ondemand decisions.
> 
> The remaining systems with ripped out powersave_bias would get plain
> ondemand governor decisions. Provided, of course, nobody uses
> powersave_bias and the functionality doesn't make any sense anyway.

Rafael, any thoughts on removing powersave_bias altogether ?

If we remove it, then is it acceptable to add an alternate callback/
handler registration to ondemand governor to account for hardware
feedback ?

Or, if we don't want to remove powersave_bias,

Then Thomas, Boris, would it be acceptable if enable the frequency
feedback feature by default with a sane powersave_bias tunable value ?
And also add proper documentation for both vanila powersave_bias and
powersave_bias with AMD frequency sensitivity loaded to
Documentation/cpu-freq/ondemand ?

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

