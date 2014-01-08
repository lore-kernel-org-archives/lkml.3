Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbaAHN0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:26:39 -0500
Received: from [85.220.129.32] ([85.220.129.32]:45504 "EHLO smtp1-3.goneo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaAHN0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:26:37 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.78
From: Lars Poeschel <poeschel@lemonage.de>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, xiaojin <jin.xiao@intel.com>,
        Ken Mills <ken.k.mills@intel.com>,
        Dirkjan Bussink <d.bussink@gmail.com>
Subject: Re: [RFC DO NOT MERGE] tty: n_gsm: support buggy modem
Date: Wed, 08 Jan 2014 14:26:03 +0100
Message-ID: <1599574.bGW69LnCZ1@lem-wkst-02>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1389113497.2735.142.camel@acox1-desk.ger.corp.intel.com>
References: <4386658.RncifLMAGy@lem-wkst-02> <20140107142050.GB32491@kroah.com> <1389113497.2735.142.camel@acox1-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 7. Januar 2014, 16:51:37 schrieb Alan Cox:
> > > modem status command, but this DV bit is not set. With this patch the
> > > modem
> > > and the whole mux is working fine. Another way makeing all this work is
> > > setting the carrier_raised function to NULL. The tty code assumes that
> > > everything is alright then.
> 
> Which means your modem has decided it doesn't yet have a carrier. Do you
> get a carrier after ATD completes with a CONNECTED message ?
> 
> (you can open with O_NDELAY to avoid blocking on the open)

Oh! Thank you! This does indeed bring up the channel. After opening 
nonblocking and writing ATD *99***1# to a muxed channel the modem sends a 
modem status command message with DV bit set.
This does in fact mean, I can only use the mux in nonblocking mode. Does this 
make sense ? Why can't I use a muxed channel with blocking IO ? I could do AT 
commands over the mux channel and the DV bit is not set (and thus TIOCM_CD is 
not set) and the modem (and the mux line discipline) is fine with it.

