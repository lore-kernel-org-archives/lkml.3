Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968173Ab3DSJwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:52:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56256 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967950Ab3DSJwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:52:31 -0400
Message-ID: <1366365149.3901.15.camel@joe-AO722>
Subject: Re: [PATCH wireless-next] rt2x00: Use more current logging styles,
 shrink object size
From: Joe Perches <joe@perches.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        rt2x00 Users List <users@rt2x00.serialmonkey.com>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 19 Apr 2013 02:52:29 -0700
In-Reply-To: <CAL1gcdOMtbzxCVLNvDK_CD-M+_SdAeL3Sja9khO9+G2bNOCz1g@mail.gmail.com>
References: <1366360406.3901.10.camel@joe-AO722>
	 <CAL1gcdOMtbzxCVLNvDK_CD-M+_SdAeL3Sja9khO9+G2bNOCz1g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 11:45 +0200, Gertjan van Wingerde wrote:
> Hi Joe,

Hello Gertjan.

> On Fri, Apr 19, 2013 at 10:33 AM, Joe Perches <joe@perches.com> wrote:
> > Reduce object size ~2% using more current logging styles.
[]
> > +/* Utility printing macros */
> > +#define rt2x00_err(dev, fmt, ...)                                      \
> > +       wiphy_err((dev)->hw->wiphy, "%s: Error - " fmt,                 \
> > +                 __func__, ##__VA_ARGS__)
> > +#define rt2x00_warn(dev, fmt, ...)                                     \
> > +       wiphy_err((dev)->hw->wiphy, "%s: Warning - " fmt,               \
> > +                 __func__, ##__VA_ARGS__)
> 
> Shouldn't this use wiphy_warn instead of wiphy_err?
> 
> > +#define rt2x00_info(dev, fmt, ...)                                     \
> > +       wiphy_err((dev)->hw->wiphy, "%s: Info - " fmt,                  \
> > +                 __func__, ##__VA_ARGS__)
> 
> Shouldn't this use wiphy_info instead of wiphy_err?

Gah, of course you're right, copy/paste dumbness.

> > +#define rt2x00_eeprom_dbg(dev, fmt, ...)                               \
> > +       wiphy_dbg((dev)->hw->wiphy, "%s: %s - " fmt,                    \
> > +                 __func__, "EEPROM recovery", ##__VA_ARGS__)

> Why do you give the "EEPROM recovery" string as extra argument instead
> of embedding it in the format string, like you do in the rt2x00_dbg
> macro for the "Debug" string?

Trivial space reduction on x86/32.
It's just a few bytes.  It may not be
a savings at all for x86/64.

I'd actually prefer to remove all the
extra "INFO/ERR/WARNING" bits from the
messages as it's a simple duplication of
the KERN_<LEVEL> and I think not useful.

> Also, please put all rt2x00_<level> next to each other, instead of
> scattering them around with the "#define DEBUG" in between them.

I'll resubmit tomorrow.

