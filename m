Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaD1E6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 00:58:13 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60681 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaD1E6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 00:58:12 -0400
Date: Mon, 28 Apr 2014 06:58:10 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 0/4] acerhdf/thermal: adding new models and appropriate
 governor
Message-ID: <20140428045810.GA30353@rhlx01.hs-esslingen.de>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <20140427185708.GA15007@rhlx01.hs-esslingen.de>
 <cone.1398640399.709208.1804.1000@galar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1398640399.709208.1804.1000@galar>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 28, 2014 at 01:13:19AM +0200, Peter Feuerer wrote:
> Hi,
> 
> Andreas Mohr writes:
> 
> > { "Acer", "AOA1....", &aao_reg_map_AOAxxx_Acer_orig_version },
> > 
> > Of course you then have the indirection of device name <-> specific
> > register values (quote: "really ugly and hard to read"?),
> > but IMHO that's ok since normally you wouldn't be too focused
> > on looking up register values (...right!?).
> > 
> > And if the next interface-breaking config change came along,
> > you'd otherwise have to add yet another register index pair...
> > (at which point some 100+ char line monsters
> > would be breathing down our neck...)
> 
> I think we have been discussing this solution a year ago or something and 
> seems like it is really time to implement it.  As I wrote in the other mail 
> to Boris, I'd like to just do a minor modification for now and then when 
> those 4 patches have been applied concentrate on implementing the splitted 
> structs.

Yup, to get things out of the way now :)


[[BTW your mail environment seems configured to have trailing blanks -
might want to "optimize" that away...]]


> > -       depends on THERMAL && ACPI
> > +       depends on THERMAL && ACPI && THERMAL_GOV_BANG_BANG
> > Do we actively depend on THERMAL (code-wise, I mean?) Or is it now an
> > implicit dependency given that we request THERMAL_GOV_BANG_BANG? If
> > implicit, then THERMAL probably ought to be removed. But if we use
> > generic thermal APIs (which we probably do), then of course we do have
> > that dependency....
> 
> There's an implicit dependency due to the request of THERMAL_GOV_BANG_BANG, so
> yes, we could remove THERMAL here.

ok. Does not seem too risky, and reduces the need for future updates.

> > "used to force thermal" --> misleading ("we used to do this, but it's
> > bad so we better do that").
> > 
> > "intended to"? "established to"? "added to"? or some simpler wording?
> 
> What do you think about this wording:
> /*
>  * this struct is used to instruct thermal layer to use bang_bang instead of
>  * default governor for acerhdf
>  */

Nicely detailed.


About the _t typedef: it's said that use of "_t" is undesirable anyway
due to being reserved for POSIX.
https://en.wikipedia.org/wiki/Typedef
http://stackoverflow.com/questions/1186072/naming-scheme-for-typedefs
As an alternative using a full "_type" is ok right?
(that's what I've been doing...)

Andreas
