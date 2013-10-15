Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab3JOOG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:06:28 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53335 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316Ab3JOOG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:06:27 -0400
Message-ID: <1381845985.2045.40.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Tue, 15 Oct 2013 07:06:25 -0700
In-Reply-To: <20131015155615.738f03d5@b012350-ux>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <87siw4xy9i.fsf@tassilo.jf.intel.com>
	 <20131014202528.GG26880@hmsreliant.think-freely.org>
	 <20131015091251.2345b918@b012350-ux>
	 <20131015133336.GF2592@two.firstfloor.org>
	 <20131015155615.738f03d5@b012350-ux>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 15:56 +0200, Sébastien Dugué wrote:
> On Tue, 15 Oct 2013 15:33:36 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > >   indeed, our typical workload is connected mode IPoIB on mlx4 QDR hardware
> > > where one cannot benefit from hardware offloads.
> > 
> > Is this with sendfile?
> 
>   Tests were done with iperf at the time without any extra funky options, and
> looking at the code it looks like it does plain write() / recv() on the socket.
> 

But the csum cost is both for sender and receiver ?

Please post the following :

perf record -g "your iperf session"

perf report | head -n 200



