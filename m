Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaBUPdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:33:19 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36371 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbaBUPdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:33:15 -0500
Date: Fri, 21 Feb 2014 15:32:39 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
Message-ID: <20140221153239.20dbb8c2@alan.etchedpixels.co.uk>
In-Reply-To: <CALCETrWEexCqH5486Qfyt22i5+MZjpETJEMTyg6FO6xOwXuraQ@mail.gmail.com>
References: <cover.1387588711.git.luto@amacapital.net>
	<15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
	<20140219151626.GA13973@katana>
	<CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
	<20140219192646.1a62521d@alan.etchedpixels.co.uk>
	<CALCETrWEexCqH5486Qfyt22i5+MZjpETJEMTyg6FO6xOwXuraQ@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm suggesting identifying a range of addresses on a bus with a "port"
> (or whatever it should be called).  Multiple ports could claim
> non-overlapping ranges on the same bus.

Which is fine until you meant a mux or a device that can be moved about
by writing to it, or has a wide range of addresses determined by
strapping.

> In this particular case (Intel LGA2011 systems), there's only one sane
> way to wire up the busses, since the memory controller *is* the smbus
> master.  According to the JEDEC spec, each DIMM slot is has three pins

Ok that helps a lot for the specific case, and you have at least in
theory got a flag between the OS and BIOS to avoid things like SMM
throwing parties on the smbus while you are using it.

