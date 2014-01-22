Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaAVKxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:53:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:35380 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaAVKxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:53:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,698,1384329600"; 
   d="scan'208";a="468946492"
Date: Wed, 22 Jan 2014 13:00:11 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH RFC 4/6] net: rfkill: gpio: add device tree support
Message-ID: <20140122110011.GU18029@intel.com>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
 <CAAVeFuLP4MkfXGG1FMauvUw_J63zRXdhGwxqYy5W98L1wCQNbw@mail.gmail.com>
 <CACRpkdYiy+sya6NqRfAmsrFOXvaa3qX=qjRuTDW1vZVSaG1+Gg@mail.gmail.com>
 <201401211335.16885.arnd@arndb.de>
 <CAAVeFuKFfAvSPYLmvWV5jjT-peZFJ8sJ2bbh4F=JAYoWLhjZpA@mail.gmail.com>
 <CACRpkdZbb=eO8YRtMn6hW0vn97PkHUo88e_o61DEC8=wPY3_PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZbb=eO8YRtMn6hW0vn97PkHUo88e_o61DEC8=wPY3_PQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:58:38AM +0100, Linus Walleij wrote:
> On Tue, Jan 21, 2014 at 3:53 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> 
> > The good (or bad, rather) thing about DT is that we can do whatever we
> > please with the new bindings: decide which name or which index
> > (doesn't matter here) a GPIO should have. However we don't have this
> > control over ACPI, where nothing guarantees that the same index will
> > be used for the same GPIO function.
> 
> It's not like ACPI will impose some tables on us and expect us to
> use them as-is no matter how crazy they are. Then indeed the whole
> idea of unifying ACPI and DT accessors would be moot and it would
> only work by mistake or as a good joke.

With the current ACPI version we really don't have much of a choice here.
Only way we can distinguish between a set of GPIOs is to use index and hope
that the vendor puts the GPIOs in the table in same order that the driver
expects :-(

This is going to get a bit better when ACPI gets properties (like Arnd
commented already) as then we can get the correct index based on a name in
a table. However, it still requires the vendor to use naming that is
suitable for Linux driver in question.

> The situation with ACPI is just like with DT, it is assumed that the
> author of these tables also look at the Linux kernel drivers to figure
> out what argument goes where and we can influence them.

I certainly hope, now that Android is becoming more and more important,
that the vendors will actually check what the Linux drivers expect and
populate the tables with such information that is suitable for both ACPI
and DT enabled driver.
