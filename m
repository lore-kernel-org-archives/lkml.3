Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaHOCah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 22:30:37 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55013 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaHOCag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 22:30:36 -0400
Date: Fri, 15 Aug 2014 04:30:30 +0200
From: Andreas Mohr <andi@lisas.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andreas Mohr <andi@lisas.de>,
        Kristina =?utf-8?Q?Mart=C5=A1enko?= 
	<kristina.martsenko@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [GIT PULL] Staging driver patches for 3.17-rc1
Message-ID: <20140815023030.GA25537@rhlx01.hs-esslingen.de>
References: <20140804190837.GA27292@kroah.com>
 <20140805041325.GA27507@rhlx01.hs-esslingen.de>
 <20140805043143.GA31519@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805043143.GA31519@kroah.com>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

late reply due to fatal environment failure, sorry.

On Mon, Aug 04, 2014 at 09:31:43PM -0700, Greg KH wrote:
> On Tue, Aug 05, 2014 at 06:13:25AM +0200, Andreas Mohr wrote:
> > Oh well, yet another driver where it became more difficult rather than
> > easier to make forward progress.
> 
> If you are willing to do the work, I will gladly revert the patch and
> look forward to patches to fix the remaining changes.

I've now done further device/driver research
and it looks like this course of action was actually best:
the keucr driver was duplicate/improved functionality of the
ene_ub6250.c driver,
with some extended card type support then relocated into ene_ub6250.c.
The card type relocation work that's still missing is SmartMedia,
but then I do have SM cards and would thus be able to test it.
Thus the duplicated keucr driver could probably stay removed,
with the penalty of having SM support lost at the moment
(since one had to switch drivers anyway
it's uncertain whether that's much of a loss).

The driver also seems to be missing several USB IDs,
as seen from IDs in keucr and Windows .inf file.

Also, firmware files are very old compared to content in current Windows driver
(but it remains to be seen whether new binaries remained compatible
with an old unchanged driver handling, especially given that on Windows
the firmware data is usefully(?) shipped right next to it,
within the same binary).

I'd like to definitely mention here
that this particular device might be well worth improving,
since as opposed to many other USB-based readers
it has a custom programming interface
plus external firmware data,
which could mean that we might be able
to add support for CompactFlash SMART readout
and/or SD card Card Information Struct readout,
on an external USB-based(!) reader.


I will have more time in the near future,
thus I should be able to work on some of these items -
after having completed some other pending driver submissions that is :-P

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
