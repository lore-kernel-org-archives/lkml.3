Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab3FWV4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 17:56:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51118 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416Ab3FWV4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:56:52 -0400
X-Sasl-enc: 0xsENqy6opULti3hBLS0PKr7+jJ9JZXwBvSMyg+tJ+pm 1372024611
Date: Sun, 23 Jun 2013 18:56:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Brice Goglin <brice.goglin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: MTRR use in drivers
Message-ID: <20130623215649.GA1288@khazad-dum.debian.net>
References: <51C3DDFA.7050204@zytor.com>
 <51C69732.1010906@gmail.com>
 <b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com>
 <20130623192936.GA28655@khazad-dum.debian.net>
 <51C75465.9060007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C75465.9060007@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jun 2013, H. Peter Anvin wrote:
> On 06/23/2013 12:29 PM, Henrique de Moraes Holschuh wrote:
> > On Sun, 23 Jun 2013, H. Peter Anvin wrote:
> >> Why do you care about performance when PAT is disabled?
> > 
> > It will regress already slow boxes.  We blacklist a LOT of P4s, PMs, etc and
> > nobody ever took the pain to track down which ones of those actually have
> > PAT+MTRR aliasing bugs.
> > 
> > These boxes have boards like the Radeon X300, which needs either PAT or MTRR
> > to not become unusable...
> 
> We're talking hardware which is now many years old, but this is causing
> very serious problems on real, modern hardware.  As far as I understand
> it, too, the blacklisting was precautionary (the only bug that I
> personally know about is a performance bug, where WC would be
> incorrectly converted to UC.)

And as far as I could find from Intel's not-that-complete public
"specification updates", we are applying the errata workaround to a few more
processors than strictly required, but since I have no idea how to write a
test case, I can't whitelist the 3rd-gen Pentium M on my T43, nor can I get
ThinkPad owners to test it for us on 1st and 2nd-gen Pentium M and report
back.

> We need a way forward here.  If it is the only way I think we would have
> to sacrifice the old machines, but perhaps something can be worked out
> (e.g. if PAT is disabled, fall back to MTRRs if available for ioremap_wc()).

I'd be quite happy with a MTRR fallback.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
