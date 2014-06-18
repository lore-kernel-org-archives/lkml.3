Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaFRPZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:25:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33314 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaFRPZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:25:10 -0400
Date: Wed, 18 Jun 2014 17:25:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
Message-ID: <20140618152505.GE24024@pd.tnic>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com>
 <20140618095739.GA24419@pd.tnic>
 <53A1A3A5.9010109@intel.com>
 <20140618144429.GD24024@pd.tnic>
 <53A1A90D.5010604@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A1A90D.5010604@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 07:58:21AM -0700, Dave Hansen wrote:
> Are you seriously asking why we would want to cull out code guaranteed
> to be unused?

Yes, I am. Don't get me wrong - I'm all for not enabling code which is
unused - I'm just questioning the actual usage case here.

Because you have this:

+config X86_INTEL_MPX
+       def_bool y
+       depends on CPU_SUP_INTEL

which means, even on !MPX Intels, you need to explicitly say "no" here.
Is this how the configuration is supposed to be done?

Or do you need to add help text to explain to people not to enable this
on !MPX machines after looking at /proc/cpuinfo first?

Am I close?

> The minuscule number of people not using a distro kernel?  Like, every
> Android and Chrome device in the world?  How about the cloud providers
> with millions of servers?

Cloud people won't be benefiting from MPX?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
