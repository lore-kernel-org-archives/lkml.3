Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182Ab3JON4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:56:18 -0400
Received: from odin2.bull.net ([129.184.85.11]:56322 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875Ab3JON4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:56:17 -0400
Date: Tue, 15 Oct 2013 15:56:15 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Andi Kleen <andi@firstfloor.org>
CC: Neil Horman <nhorman@tuxdriver.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple
 alu's
Message-ID: <20131015155615.738f03d5@b012350-ux>
In-Reply-To: <20131015133336.GF2592@two.firstfloor.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	<87siw4xy9i.fsf@tassilo.jf.intel.com>
	<20131014202528.GG26880@hmsreliant.think-freely.org>
	<20131015091251.2345b918@b012350-ux>
	<20131015133336.GF2592@two.firstfloor.org>
Organization: BULL
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.192.1.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 15:33:36 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> >   indeed, our typical workload is connected mode IPoIB on mlx4 QDR hardware
> > where one cannot benefit from hardware offloads.
> 
> Is this with sendfile?

  Tests were done with iperf at the time without any extra funky options, and
looking at the code it looks like it does plain write() / recv() on the socket.

  Sébastien.

> 
> For normal send() the checksum is done in the user copy and for receiving it
> can be also done during the copy in most cases
> 
> -Andi
