Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaBYTyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:54:43 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:57488 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaBYTyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:54:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140221153239.20dbb8c2@alan.etchedpixels.co.uk>
References: <cover.1387588711.git.luto@amacapital.net> <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
 <20140219151626.GA13973@katana> <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
 <20140219192646.1a62521d@alan.etchedpixels.co.uk> <CALCETrWEexCqH5486Qfyt22i5+MZjpETJEMTyg6FO6xOwXuraQ@mail.gmail.com>
 <20140221153239.20dbb8c2@alan.etchedpixels.co.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 25 Feb 2014 11:54:20 -0800
Message-ID: <CALCETrXhJPHyWP7NAujbshJc_fBYsGxp_MK752G4Nt8r9yMEmg@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 7:32 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>> I'm suggesting identifying a range of addresses on a bus with a "port"
>> (or whatever it should be called).  Multiple ports could claim
>> non-overlapping ranges on the same bus.
>
> Which is fine until you meant a mux or a device that can be moved about
> by writing to it, or has a wide range of addresses determined by
> strapping.

For muxes: isn't there already a system in place for dealing with them?

For things with addresses determined by strapping: my vague proposal
is explicitly intended to support them.  (DIMMs are such a device.)
Whoever instantiates the i2c "ports" is supposed to *know* the
topology, including which straps are set where.  In some cases, that
data could come from ACPI or DT.  In other cases, it's enumerated
directly.  The idea would be to allow the code that figures out the
topology (both physical connectivity and straps) to be separated from
the code that talks to the i2c endpoints.

Just specifying the address ranges might be insufficient for things
that are more flexible than DIMMs, though -- it might be necessary to
say "this port has these addresses and this kind of device lives at
this address".

--Andy
