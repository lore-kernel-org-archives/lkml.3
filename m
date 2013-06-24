Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3FXACa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 20:02:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47699 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553Ab3FXAC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 20:02:29 -0400
X-Sasl-enc: rlD559pa74msre20RwVkwDDnmZb54K8xW0OEtjSEu8gt 1372032147
Date: Sun, 23 Jun 2013 21:02:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Brice Goglin <brice.goglin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: MTRR use in drivers
Message-ID: <20130624000224.GA2832@khazad-dum.debian.net>
References: <51C3DDFA.7050204@zytor.com>
 <51C69732.1010906@gmail.com>
 <b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com>
 <20130623192936.GA28655@khazad-dum.debian.net>
 <51C75465.9060007@zytor.com>
 <20130623215649.GA1288@khazad-dum.debian.net>
 <51C7725C.5090801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C7725C.5090801@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jun 2013, H. Peter Anvin wrote:
> On 06/23/2013 02:56 PM, Henrique de Moraes Holschuh wrote:
> > 
> > And as far as I could find from Intel's not-that-complete public
> > "specification updates", we are applying the errata workaround to a few more
> > processors than strictly required, but since I have no idea how to write a
> > test case, I can't whitelist the 3rd-gen Pentium M on my T43, nor can I get
> > ThinkPad owners to test it for us on 1st and 2nd-gen Pentium M and report
> > back.
> 
> Which specific erratum are you referring to, here?  The "WC becomes UC"
> erratum?  I don't think there is a sane testcase for it since it needs a
> very complicated setup to trigger.

There are at least two different nasty PAT issues that are not always
critical, and one that outright hangs the processor (if the unsupported
aliasing of WB with UC/WC happens).

Interestingly enough, most of the P4-Xeons and P4 do not appear to have the
"WC becomes UC" errata.

However, LOTS of P4, M-P4, Xeon PIII, Xeon, and Pentium M have a bug where
the four highest entries in the PAT table are inactive (aliased to the four
lowest entries) in mode B (PSE) and mode C (PAE) for 4k pages.  They work
fine for large pages.

Also, lots of them can hang if you ever alias WB with UC or WC (which is
apparently an unsupported configuration anyway, or so it says in the
errata).

There are other weird aliasing nasties, such as one where you get memory
corruption if you alias WB data with code (being accessed as UC or WC) in
the same cacheline, and some stuff such as weirdness should the page table
be on WC memory...

I can track down most of the CPUIDs involved if you want, but someone from
Intel would be better (I assume they actually have access to the errata
documentation in some less idiotic way than reading a ton of badly indexed
PDFs that take forever to find in their site).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
