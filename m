Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaB1TPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:15:16 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:48620 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaB1TPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:15:13 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-05-5310e0402597
Date: Fri, 28 Feb 2014 16:15:06 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luck, Tony" <tony.luck@intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rui Wang <ruiv.wang@gmail.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
Message-id: <20140228161506.62889d46@samsung.com>
In-reply-to: <CALCETrVwSj3KGcPqQD2Kd9W5FCHyPWLukCVr0BZLdQc_Fgz4qA@mail.gmail.com>
References: <cover.1387588711.git.luto@amacapital.net>
 <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
 <20140219151626.GA13973@katana>
 <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
 <20140220035128.14da0f79.m.chehab@samsung.com>
 <3908561D78D1C84285E8C5FCA982C28F31DCC6F8@ORSMSX106.amr.corp.intel.com>
 <CALCETrVwSj3KGcPqQD2Kd9W5FCHyPWLukCVr0BZLdQc_Fgz4qA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/hEF2HBwLBBvvey1o0/o206Pj7hdHi
	8q45bBZPFp5hsli9toHVYuKhJ2wWby7cY7FYeWIWswOHx/03f1k8ds66y+6xeM9LJo8rDSfZ
	PHZ+b2D3OHnqCYvH501yAexRXDYpqTmZZalF+nYJXBkz1x5lLbjMXXHoUCtbA+Mczi5GTg4J
	AROJKz93s0DYYhIX7q1n62Lk4hASWMIosf59IytIQkigh0ni03VvEJtFQFXi5MpJ7CA2m4CR
	xKvGFrAaEQFNiZdT5rOANDMLrGeSWHf1CdhUYQFriR29B8FsXgFDiY2TpzCB2JwCwRINJ7ax
	QCzYyCyxdjU3xBVOEq9eT2aCqBeU+DH5HlgNs4CWxOZtTawQtrzE5jVvmScwCsxCUjYLSdks
	JGULGJlXMYqWFicXFCel5xrqFSfmFpfmpesl5+duYoTEQNEOxmcbrA4xCnAwKvHwSiwSCBZi
	TSwrrsw9xCjBwawkwjvhOlCINyWxsiq1KD++qDQntfgQIxMHp1QD456IubNdTjB9+WJ1/PRk
	1+f2sYebmWTnhb1hypBdtDX25n/f9+f57Ju0lwitsOa7Lzbx1yfNyzUzeeMaykoquMXr+Bu+
	G9z7++RX4LayBYonDDQTxDY+fOj0cm5J6d2KO3aTnlafOaf6Xfmu3Jn9h5r+Rz/QuVbDMPtE
	sITTh55fstvenOX6a63EUpyRaKjFXFScCABWntV5XwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 19 Feb 2014 17:39:07 -0800
Andy Lutomirski <luto@amacapital.net> escreveu:

> On Wed, Feb 19, 2014 at 11:03 AM, Luck, Tony <tony.luck@intel.com> wrote:
> >> (I'm c/c Tony here, as he also shared the same concern that I had on a
> >> previous feedback about using I2C to talk with the DIMM).
> >
> > Correct - I've heard the same issues that reads on I2C can be misinterpreted
> > as writes ... and oops, you have a brick.
> 
> Is this true on DDR3 DIMMs, i.e. anything that's compatible with
> LGA2011?  If you plug a DIMM into an LGA2011 board's memory slot,
> then, one way or another, it's very likely that there will be TSOD
> traffic, if for no other purpose than to determine that there is no
> TSOD present.  TSOD traffic consists of reads and writes, both with
> and without register numbers.  (Sorry, I can never remember the smbus
> terminology here -- the relevant transactions are two-byte reads and
> two-byte writes, both with a command specified and without one.  One
> of the bits in the iMC SMBUS registers tells the controller which kind
> of read to use to probe the thermometer.)

An update on that: I double-checked with a DIMM manufacturer.
I was told that some DIMM models have write protect circuits but
others don't.

So, yeah, accessing it could eventually brick the DIMM, depending 
on the DIMM model, if such driver won't block I2C write ops or
if the BIOS is also trying to access the bus at the same time.

Regards,
Mauro
