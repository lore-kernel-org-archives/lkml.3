Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaFJVQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:16:36 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47740 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaFJVQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:16:34 -0400
MIME-Version: 1.0
In-Reply-To: <1402323702.11505.18.camel@umadbro>
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
 <1401468984-24575-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
 <1401825693.4157.44.camel@jlt4.sipsolutions.net> <20140603221837.GU26450@wotan.suse.de>
 <1402323702.11505.18.camel@umadbro>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 10 Jun 2014 14:16:11 -0700
X-Google-Sender-Auth: 8NEutbTOLVn492QjHPV_4MLxOlY
Message-ID: <CAB=NE6Wi+SLPSuGiGeFpJO4FVHfHpSpsDfsccAi9cPyhmL6NwQ@mail.gmail.com>
Subject: Re: [RFC 1/4] cfg80211: Add channel flags limiting availability to
 OCB mode only
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Liraz Perelmooter <liraz.perelmooter@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>,
        "wireless-regdb@lists.infradead.org" 
	<wireless-regdb@lists.infradead.org>,
        Michael Green <green@qti.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 7:21 AM, Rostislav Lisovy <lisovy@gmail.com> wrote:
> Dear Luis;
> Thank you for the introduction in the wireless-regdb mailing-list.
>
> On Wed, 2014-06-04 at 00:18 +0200, Luis R. Rodriguez wrote:
>> Rostislav, can you provide documentation references which would
>> clarify
>> the stance on 802.11p and restrictions for only allowing  OCB mode?
>
> If I may cite the 802.11-2012 standard:
> -- 1st Quote
> 4.3.11 STA transmission of data frames outside the context of a BSS
>
> Communication of data frames when dot11OCBActivated is true might take
> place in a frequency band that is dedicated for its use, and such a band
> might require licensing depending on the regulatory domain. A STA for
> which dot11OCBActivated is true initially transmits and receives on a
> channel known in advance, either through regulatory designation or some
> other out-of-band communication.
> -- End of quote

OK the spec does not rule out communication on that special band for
regular operation as such that special band is mentioned in the
context of OCB communication, but it does say that the frequency range
may be licensed. As it stands the public wireless-regdb only covers
unlicensed frequency ranges, but it obviously can support licensed
frequency ranges, just that the distribution mechanism and integration
of the wireless-regdb files then would have to be done separately
through separate distributors -- ie, not upstream. If the OCB bands
are unlicensed then we can surely add them to wireless-regdb, however
it remains unclear if those bands are unlicensed if we can use them
for regular non OCB communication.

Follow this logic to move forward then:

  * Poke folks to see if the US band for OCB is licensed or unlicensed
  * Poke folks to see if the EU band for OCB is licensed or unlicensed

  * If the bands are licensed then the wireless-regdb changes that
would be needed imply that a wireless-regdb needs to be provided to
whatever customer by whomever is licensing that entity for usage of
that band, that is, we upstream can be removed from the equation of
the distribution. The upstream kernel however would require a flag for
frequency ranges for OCB frequency ranges. Although the regulatory
classes specify a few for the US and EU, this can likely change. I
forget if the regulatory class can be interpreted through IEs, if so
and if the specification is going to remain static I can envision the
ability to hard code the OCB frequency ranges upstream but you'd then
need to parse these things.

  * If the bands are *not licensed* there is one corner case that I
still think should be reviewed by regulatory folks: having an OCB
frequency range unlicensed under the current reading of the
specification of 802.11-2012 means that 802.11 devices *can* use them
for OCB, however if OCB is not enabled on the device it seems to be
that OCB bands can be used for non OCB communication. Furthermore
4.3.11 seems to be saying that it is only optional to use a dedicated
frequency for OCB, OCB can happen on other frequency ranges.

> -- 2nd Quote
> Annex E (normative) Country elements and operating classes
> E.2.3 5.9 GHz band in the United States (5.850–5.925 GHz)
> ...
> STAs shall have dot11OCBActivated set to true.

So all STAs in the US wil have OCB activated? I fail to understand how
Annex E should be read in the context of operating classes.

> E.2.4 5.9 GHz band in Europe (5.855–5.925 GHz)
> STAs shall have dot11OCBActivated set to true.

Ditto.


  Luis
