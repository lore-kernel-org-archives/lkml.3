Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaJEVt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:49:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39699 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbaJEVtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:49:20 -0400
X-Sasl-enc: 8oRIF1Ha4COjpXmiC4bOhsDzAum/cOjm89/yAfy9DQ5a 1412545760
Date: Sun, 5 Oct 2014 18:49:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 1/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20141005214907.GA28396@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-2-git-send-email-hmh@hmh.eng.br>
 <20141005173453.GC9377@pd.tnic>
 <20141005193703.GB24081@khazad-dum.debian.net>
 <20141005211304.GA12003@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005211304.GA12003@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Oct 2014, Borislav Petkov wrote:
> On Sun, Oct 05, 2014 at 04:37:03PM -0300, Henrique de Moraes Holschuh wrote:
> > Not realy, because it got you confused! :-)
> 
> No, it didn't get me confused - it got you confused that I'm confused.

Indeed.

> You need to read the comment as a *whole*. The zero value is special
> because it is *used* to *denote* a failure. You can use any other
> invalid revision value for that matter.

Well, the new wording is confusing me... so maybe we can try a third time?
:-)

> Maybe "denote" was not precise enough - maybe it should say "0 is an
> invalid microcode revision and is used to detect the failure of a
> microcode update" or similar. Yeah, "detect" sounds better.

How about this:

	/*
	 * 0 is not a valid microcode revision as it is used to detect the
	 * absence of any sucessful microcode update since reset /
	 * power-on, see MSR 0x8b (IA32_BIOS_SIGN_ID):
	 *
	 * "It is required that this register field be pre-loaded with zero
	 * prior to executing the CPUID, function 1. If the field remains
	 * equal to zero, then there is no microcode update loaded. Another
	 * non-zero value will be the signature."
	 */

?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
