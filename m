Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaIDQwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:52:10 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:55545 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaIDQwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:52:08 -0400
Date: Thu, 4 Sep 2014 17:50:44 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jakub Jelinek <jakub@redhat.com>, Mikael Pettersson <mikpelinux@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Henderson <rth@twiddle.net>, Oleg Nesterov <oleg@redhat.com>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
Subject: Re: bit fields && data tearing
Message-ID: <20140904175044.4697aee4@alan.etchedpixels.co.uk>
In-Reply-To: <540859EC.5000407@hurleysoftware.com>
References: <20140712181328.GA8738@redhat.com>
	<54079B70.4050200@hurleysoftware.com>
	<1409785893.30640.118.camel@pasglop>
	<21512.10628.412205.873477@gargle.gargle.HOWL>
	<20140904090952.GW17454@tucnak.redhat.com>
	<540859EC.5000407@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Besides updating the documentation, it may make sense to do something
> arch-specific. Just bumping out storage on arches that don't need it
> seems wasteful, as does generating bus locks on arches that don't need it.
> Unfortunately, the code churn looks unavoidable.

The arch specific is pretty much set_bit and friends. Bus locks on a
locally owned cache line should not be very expensive on anything vaguely
modern, while uniprocessor boxes usually only have to generate set_bit
as a single instruction so it is interrupt safe.

Alan
