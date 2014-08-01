Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaHAOAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:00:46 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:34579 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbaHAOAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:00:44 -0400
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: "Luis R. Rodriguez" <mcgrof@suse.com>, Rostislav Lisovy <lisovy@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Liraz Perelmooter <liraz.perelmooter@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        s.sander@nordsys.de, jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>,
        "wireless-regdb\@lists.infradead.org" 
	<wireless-regdb@lists.infradead.org>,
        Michael Green <green@qti.qualcomm.com>,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        Thierry Ernst <thierry.ernst@yogoko.fr>
Subject: Regulatory of 5.9 GHz band and OCB mode (was: [RFC 1/4] cfg80211: Add channel flags limiting availability to OCB mode only)
In-Reply-To: <CAB=NE6Wi+SLPSuGiGeFpJO4FVHfHpSpsDfsccAi9cPyhmL6NwQ@mail.gmail.com>
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz> <1401468984-24575-2-git-send-email-rostislav.lisovy@fel.cvut.cz> <1401825693.4157.44.camel@jlt4.sipsolutions.net> <20140603221837.GU26450@wotan.suse.de> <1402323702.11505.18.camel@umadbro> <CAB=NE6Wi+SLPSuGiGeFpJO4FVHfHpSpsDfsccAi9cPyhmL6NwQ@mail.gmail.com>
User-Agent: Notmuch/0.18.1+51~gbbbdf04 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 01 Aug 2014 16:00:34 +0200
Message-ID: <8761iccnst.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Luis and others,

I work with Rostislav on the Linux support of ITS-G5. I did some
research on the regulatory staff for 5.9 GHz band. See my findings below
and sorry for long delay of my reply.

On Tue, Jun 10 2014, Luis R. Rodriguez wrote:
> On Mon, Jun 9, 2014 at 7:21 AM, Rostislav Lisovy <lisovy@gmail.com> wrote:
>> Dear Luis;
>> Thank you for the introduction in the wireless-regdb mailing-list.
>>
>> On Wed, 2014-06-04 at 00:18 +0200, Luis R. Rodriguez wrote:
>>> Rostislav, can you provide documentation references which would
>>> clarify
>>> the stance on 802.11p and restrictions for only allowing  OCB mode?
>>
>> If I may cite the 802.11-2012 standard:
>> -- 1st Quote
>> 4.3.11 STA transmission of data frames outside the context of a BSS
>>
>> Communication of data frames when dot11OCBActivated is true might take
>> place in a frequency band that is dedicated for its use, and such a band
>> might require licensing depending on the regulatory domain. A STA for
>> which dot11OCBActivated is true initially transmits and receives on a
>> channel known in advance, either through regulatory designation or some
>> other out-of-band communication.
>> -- End of quote
>
> OK the spec does not rule out communication on that special band for
> regular operation as such that special band is mentioned in the
> context of OCB communication, but it does say that the frequency range
> may be licensed. As it stands the public wireless-regdb only covers
> unlicensed frequency ranges, but it obviously can support licensed
> frequency ranges, just that the distribution mechanism and integration
> of the wireless-regdb files then would have to be done separately
> through separate distributors -- ie, not upstream. If the OCB bands
> are unlicensed then we can surely add them to wireless-regdb, however
> it remains unclear if those bands are unlicensed if we can use them
> for regular non OCB communication.
>
> Follow this logic to move forward then:
>
>   * Poke folks to see if the US band for OCB is licensed or unlicensed
>   * Poke folks to see if the EU band for OCB is licensed or unlicensed

I only researched status in the EU. In summary, the band is unlicensed.

The relevant document for Europe is 2008/671/EC (see below). This was
confirmed to us by Czech Telecommunication Office which is responsible
for the administration of radio frequencies in the Czech republic.

The document can be found at
http://www.erodocdb.dk/docs/doc98/official/pdf/2008671EC.pdf and its
full name is "2008/671/EC, Commission Decision of 5 August 2008 on the
harmonised use of radio spectrum in the 5 875-5 905 MHz frequency band
for safety-related applications of Intelligent Transport Systems (ITS)".

  Few quotes from the document:

  Article 3 §1:

        Member States shall, not later than six months after entry
        into force of this Decision, designate the frequency band
        5 875-5 905 MHz for Intelligent Transport Systems and, as
        soon as reasonably practicable following such designation,
        make that frequency band available on a non-exclusive
        basis.

        Such designation shall be in compliance with the
        parameters set out in the Annex.

  Annex:

        Maximum spectral power density (mean e.i.r.p.): 23 dBm/MHz
        Maximum total transmit power (mean e.i.r.p.):   33 dBm
        Channel access and occupation rules:

            Techniques to mitigate interference that provide at least
            equivalent performance to the techniques described in
            harmonised standards adopted under Directive 1999/5/EC
            must be used. These require a transmitter power control
            (TPC) range of at least 30 dB.

  Intro (8):

        Harmonised standard EN 302 571 [...], thus ensuring that
        compliant ITS equipment avoids causing harmful interference.

  The EN 302 571 standard describes in detail the technical parameters
  mentioned above. See
  http://www.etsi.org/deliver/etsi_en/302500_302599/302571/01.01.01_60/en_302571v010101p.pdf

  This all means that the band in unlicensed and can be used by anybody
  compliant with the annex parameters. This interpretation was explicitly
  confirmed by Czech Telecommunication Office.

I've also found the document ECC/DEC/(08)01 (see below) which predates
2008/671/EC, but since it also mentions 2008/671/EC it seems it is
basically the same thing.

ECC Decision of 14 March 2008 on the harmonised use of the 5875-5925
MHz frequency band for Intelligent Transport Systems (ITS)

  (ECC/DEC/(08)01) (2008/671/EC)

  [http://www.erodocdb.dk/docs/doc98/official/Pdf/ECCDec0801.pdf]

  The document, among others, says:

  3. that CEPT administrations shall designate the frequency sub-band
     5875-5905 MHz on a non-exclusive basis for ITS road safety
     applications;

  8. that CEPT administrations shall exempt in-vehicle ITS equipment
     from individual licensing;

>   * If the bands are *not licensed* there is one corner case that I
> still think should be reviewed by regulatory folks: having an OCB
> frequency range unlicensed under the current reading of the
> specification of 802.11-2012 means that 802.11 devices *can* use them
> for OCB, however if OCB is not enabled on the device it seems to be
> that OCB bands can be used for non OCB communication. Furthermore
> 4.3.11 seems to be saying that it is only optional to use a dedicated
> frequency for OCB, OCB can happen on other frequency ranges.

I see it similarly.

The use of OCB is not a regulatory requirement. As it was mentioned by
Rostislav, IEEE 802.11-2012 specifies in section "E.2.4 5.9 GHz band in
Europe (5.855–5.925 GHz)":

    STAs shall have dot11OCBActivated set to true.

Section 4.3.11 then reads:

    When dot11OCBActivated is true, a STA is not a member of a BSS and
    it does not utilize the IEEE 802.11 authentication, association,
    or data confidentiality services.

Note that magic words like "shall" or "should" are not present in this
text.

I would interpret this as that OCB mode should be forced in the
5.855–5.925 GHz band (i.e. hard-coded in the Linux kernel) and that no
other modes should be allowed there.

Section 10.20 uses proper words:

    When a STA joins a BSS, it shall set dot11OCBActivated to false. The STA
    shall keep dot11OCBActivated false while joined with the BSS or while
    the STA is the AP within a BSS. If a STA does not include the
    dot11OCBActivated MIB attribute, the STA shall operate as if the
    attribute is false.

The other question is whether OCB mode should be allowed in other
frequency bands. As far as I know, nothing prevents it.

>> -- 2nd Quote
>> Annex E (normative) Country elements and operating classes
>> E.2.3 5.9 GHz band in the United States (5.850–5.925 GHz)
>> ...
>> STAs shall have dot11OCBActivated set to true.
>
> So all STAs in the US wil have OCB activated? I fail to understand how
> Annex E should be read in the context of operating classes.
>
>> E.2.4 5.9 GHz band in Europe (5.855–5.925 GHz)
>> STAs shall have dot11OCBActivated set to true.
>
> Ditto.

I understand that dot11OCBActivated can be changed at runtime. STAs
operating in the mentioned band "shall have dot11OCBActivated set to
true".

Best regards,
-Michal
