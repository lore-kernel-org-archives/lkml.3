Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbaHFTR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:17:57 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:39617 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbaHFTR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:17:56 -0400
Date: Wed, 6 Aug 2014 21:17:44 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: "Koehrer Mathias (ETAS/ESW5)" <mathias.koehrer@etas.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] Fix e1000e with Intel 82572EI that has no hardware
 timestamp support
Message-ID: <20140806191744.GB6611@netboy>
References: <bbcbf584e3624059bf7a0d2186fec6b4@FE-MBX1012.de.bosch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbcbf584e3624059bf7a0d2186fec6b4@FE-MBX1012.de.bosch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 02:32:16PM +0000, Koehrer Mathias (ETAS/ESW5) wrote:
> With the Intel 82527EI (driver: e1000e) there is an issue when running 
> the ptpd2 program, that leads to a kernel oops.
> The reason is here that in e1000_xmit_frame() a work queue will be 
> scheduled that has not been initialized in this case.
> The work queue "tx_hwstamp_work" will only be initialized if 
> adapter->flags & FLAG_HAS_HW_TIMESTAMP set.
> This check is missing in e1000_xmit_frame().

Why all the ragged lines?  Better to use an editor that knows how to
justify a paragraph, more like this:

With the Intel 82527EI (driver: e1000e) there is an issue when running
the ptpd2 program, that leads to a kernel oops.  The reason is here
that in e1000_xmit_frame() a work queue will be scheduled that has not
been initialized in this case.  The work queue "tx_hwstamp_work" will
only be initialized if adapter->flags & FLAG_HAS_HW_TIMESTAMP set.
This check is missing in e1000_xmit_frame().

That not only looks nicer, but it is also more readable.

Thanks,
Richard
