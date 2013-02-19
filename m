Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab3BSPF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:05:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41649 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932995Ab3BSPFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:05:55 -0500
Date: Tue, 19 Feb 2013 16:05:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Peter Feuerer <peter@piie.net>, Alexander Lam <azl@andrew.cmu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Mohr <andi@lisas.de>
Subject: Re: thermal governor: does it actually work??
Message-ID: <20130219150551.GL26623@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Zhang Rui <rui.zhang@intel.com>, Peter Feuerer <peter@piie.net>,
	Alexander Lam <azl@andrew.cmu.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andreas Mohr <andi@lisas.de>
References: <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com>
 <20130215154931.GA26213@rhlx01.hs-esslingen.de>
 <CACWwPiuk0GynEwe3RuKndWnsYwTuPhO0ob6sJ6ve34u1_RtkYw@mail.gmail.com>
 <20130216214712.GA13494@pd.tnic>
 <cone.1361068993.271211.4532.1000@galar>
 <20130217140908.GA20323@pd.tnic>
 <cone.1361115717.636831.25189.1000@galar>
 <20130218135012.GB16622@pd.tnic>
 <cone.1361206053.493518.2246.1000@galar>
 <1361285464.2323.20.camel@rzhang1-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1361285464.2323.20.camel@rzhang1-mobl4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 10:51:04PM +0800, Zhang Rui wrote:
> Okay, here I see the problem, say you want to turn on the fan at 60C and
> turn it off at 55C, is this what you want?
> hmmm, is it possible to do some tricks in acerhdf driver?
> say,
> only one active trip point as before. but change acerhdf_get_trip_temp
> to:
> acerhdf_get_trip_temp()
> {
> 	if (fan is on)
> 		return 55;
> 	else
> 		return 60;
> }
> 
> In this way, when the fan is off and the temperature is raising, the fan
> will be turned on at 60C because we have an active trip point of 60C.
> And when the fan is turned on and the temperature starts to drop, the
> fan will be turned off at 55C.

Makes a sense to me. I was questioning the need for 4 trip points too.
We probably would need a second, critical trip point though, just in
case.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
