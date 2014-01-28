Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaA1K0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:26:34 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53894 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775AbaA1K0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:26:32 -0500
X-Sasl-enc: ZP/k3fAKuRqUyDfHnRxs0CvH4WcKed+CRV89nDNvnmiu 1390904790
Date: Tue, 28 Jan 2014 08:26:27 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] x86, microcode: Add option to allow downgrading of
 microcode
Message-ID: <20140128102626.GA32249@khazad-dum.debian.net>
References: <1390598339-18740-1-git-send-email-andi@firstfloor.org>
 <1390598339-18740-2-git-send-email-andi@firstfloor.org>
 <20140125163558.GC25531@khazad-dum.debian.net>
 <20140125181409.GE20765@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140125181409.GE20765@two.firstfloor.org>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jan 2014, Andi Kleen wrote:
> On Sat, Jan 25, 2014 at 02:35:58PM -0200, Henrique de Moraes Holschuh wrote:
> > On Fri, 24 Jan 2014, Andi Kleen wrote:
> > > For testing purposes it can be useful to downgrade microcode.
> > > Normally the driver only allows upgrading.
> > 
> > The code is not prepared to work correctly when downgrading is allowed, in
> > the presence of shadowed microcode.  When a firmware request results in more
> 
> As I wrote it's only for testing purposes when you know what you're doing
> (typically with a special micro code file)
> 
> Your whole argument is irrelevant, as it only applies to normal users
> who should never use this option.

It certainly could become a lot less relevant if any indication is given to
normal users that they should never enable the feature unless they really
know what they're doing.

It is NOT "only for testing purposes" when that fact is written nowhere an
user would see.

> > Also, since you're going to mess with this, why don't you implement the
> > correct semanthics for microcode with the sign bit set?  Making it signed
> > actually makes the current code behaviour worse.
> > 
> > Refer to: http://lkml.org/lkml/2011/3/21/522
> 
> I don't think it makes it worse. In fact I'm essentially implementing
> Burt's request "for explicit user action" with the new override option.

You're correct.  It doesn't make it worse, it makes it better.  Your change
effectively forbids loading pre-release microcode on a box which has
production microcode, unless "downgrade mode" is enabled.

This is different from what Burt requested, but if you're implementing a
downgrade mode, it is certainly a much better behavior.

> Anyways I suppose your rant killed the patch anyways. Congratulations!

You decided to ignore feedback you got weeks ago that required just adding a
comment to the code or to the commit log to address.  Whether or not you
consider said feedback particularly interesting or relevant does NOT give
you the right to just handwave it away only to later blame others should the
patch not get accepted.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
