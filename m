Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab3EXMKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:10:38 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:21025 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3EXMKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:10:37 -0400
Date: Fri, 24 May 2013 14:10:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Mylene Josserand <Mylene.Josserand@navocap.com>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [I2C] informations + advice about messages handling
Message-ID: <20130524141010.1b3590b4@endymion.delvare>
In-Reply-To: <CAK7N6vqqG68c4vx1uBsNLF8zpSRQWwY5jERqjVYKE7NkEEzFSA@mail.gmail.com>
References: <CA78C307B8F06747967D122FC656B153986448@SERVEUR0.nvp.local>
	<CAK7N6vpg6QUAKODKO2Msr4+GTASLDpA2cG1teQV3yiwt7D4SSw@mail.gmail.com>
	<20130524094407.61d0ec42@endymion.delvare>
	<CAK7N6vqqG68c4vx1uBsNLF8zpSRQWwY5jERqjVYKE7NkEEzFSA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013 16:29:36 +0530, anish singh wrote:
> On Fri, May 24, 2013 at 1:14 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > On Fri, 24 May 2013 12:52:40 +0530, anish singh wrote:
> >> http://thread.gmane.org/gmane.linux.kernel/1410276
> >
> > This is for a specific case. The general case is handled by the
> > per-adapter mutex for years now. 2.6.32 should be just fine in this
> > respect.
>
> I may be mis-understanding here but when two client wants to
> communicate with same master and at the same
> time how does that happen?

In general clients (slaves in I2C terminology) do not initiate
transactions, it's the master's job.

> In the thread I mentioned client pulls the line low indicating that
> it wants to own the bus and waits for some time and then checks
> if the line is still low or not.If it is still low then it owns the bus
> and start transaction and if clients see otherwise it releases the
> bus and tries again after some time.How is that handled in the
> previous kernel?

That particular scenario is not handled by earlier kernels, but this is
a very special case. In most cases (including Mylène's as far as I can
see) it is not needed because there is a single master on the segment.
And even with multiple masters, I2C bus arbitration normally takes place
transparently. Only when the standard bus arbitration can't work for
some reason, the code you mentioned is needed.

-- 
Jean Delvare
