Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaHFQHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:07:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37784 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaHFQHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:07:04 -0400
Date: Wed, 6 Aug 2014 18:06:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Lan, Tianyu" <tianyu.lan@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "huawei.libin@huawei.com" <huawei.libin@huawei.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: Re: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
Message-ID: <20140806160652.GD27033@pd.tnic>
References: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com>
 <20140804102301.GB4808@pd.tnic>
 <53E04457.2060507@intel.com>
 <20140805075419.GA18234@pd.tnic>
 <53E0A3EE.50708@intel.com>
 <20140806110748.GC27033@pd.tnic>
 <4CFBC02C07DA244CA19D6815A05BE6EE0119E1CF@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CFBC02C07DA244CA19D6815A05BE6EE0119E1CF@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 06, 2014 at 01:13:21PM +0000, Lan, Tianyu wrote:
> Have you tried my attached kernel config file? When someone reported
> the issue to me, I also was very hard to reproduce the issue by my
> own config file. Maybe once 100 tries. But I can reproduced the issue
> every time with the attached configure file on several my machines and
> even on server.

first of all, please do not top-post:

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

Now, it looks like the issue is timing-related, depending on when we're
going to see CPU_DEAD, before or after the msleep. Thus, if some distro
config runs more crap on the suspend path and we don't see the CPU_DEAD
before we sleep for 100ms, then we get to wait at least once and it
shows in the suspend trace.

So, using the completion timeout seems like a net improvement for such
configs and thus for any config.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
