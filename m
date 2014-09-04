Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaIDT4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:56:48 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:64223 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076AbaIDT4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:56:47 -0400
Message-ID: <1409860605.5546.114.camel@x220>
Subject: Re: [PATCH] [media] dib0090: remove manual configuration system
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Sep 2014 21:56:45 +0200
In-Reply-To: <20140904123613.6fa4d818.m.chehab@samsung.com>
References: <1400762887.16407.4.camel@x220>
	 <20140904123613.6fa4d818.m.chehab@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2014 19:56:45.0958 (UTC) FILETIME=[5B40EA60:01CFC87A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Thu, 2014-09-04 at 12:36 -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 22 May 2014 14:48:07 +0200
> Paul Bolle <pebolle@tiscali.nl> escreveu:
> 
> > dib0900.c has always shipped with its own, manual, configuration
> > system. There a three problems with it.
> > 
> > 1) macros that are defined, but not used:
> >     CONFIG_SYS_DVBT
> >     CONFIG_DIB0090_USE_PWM_AGC
> > 
> > 2) checks for macros that are always true:
> >     CONFIG_SYS_ISDBT
> >     CONFIG_BAND_CBAND
> >     CONFIG_BAND_VHF
> >     CONFIG_BAND_UHF
> > 
> > 3) checks for macros that are never defined and are always false:
> >     CONFIG_BAND_SBAND
> >     CONFIG_STANDARD_DAB
> >     CONFIG_STANDARD_DVBT
> >     CONFIG_TUNER_DIB0090_P1B_SUPPORT
> >     CONFIG_BAND_LBAND
> > 
> > Remove all references to these macros, and, of course, remove the code
> > hidden behind the macros that are never defined too.
> 
> IMHO, it is OK to remove the macros that are always true and
> the ones that aren't used.

I see. I hope to send a v2 that does that one of these days.

> However, I don't like the idea of
> removing the other macros. This is a tuner driver that can be used
> on other bands, and some day we might end implementing analog support
> for the Dibcom driver or to add something that will require the code
> there. So, IMHO, better to keep the code there.

But would you consider a patch that at least moves those macros out of
the CONFIG_* namespace (ie, a patch that prefixes those macros with,
say, DIB0090_)?


Paul Bolle

