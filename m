Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaEWOA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:00:27 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57549 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaEWOAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:00:25 -0400
Message-ID: <1400853622.5367.196.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: skbuff truesize incorrect.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Jim Baxter <jim_baxter@mentor.com>, David Miller <davem@davemloft.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kamal@canonical.com, edumazet@google.com,
        mszeredi@suse.cz, fw@strlen.de
Date: Fri, 23 May 2014 07:00:22 -0700
In-Reply-To: <87vbsw4z5x.fsf@nemi.mork.no>
References: <537E4AFD.20304@mentor.com>
	 <1400792295.5367.174.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1400792601.5367.176.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140522.171033.1040508444998374401.davem@davemloft.net>
	 <87ppj5vupf.fsf@nemi.mork.no> <537F0DCA.6030901@mentor.com>
	 <87vbsw4z5x.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-23 at 11:33 +0200, Bjørn Mork wrote:
> Jim Baxter <jim_baxter@mentor.com> writes:
> 
> >> I'll create and test a patch for the cdc_ncm host driver unless someone
> >> else wants to do that. I haven't really played with the gadget driver
> >> before, so I'd prefer if someone knowing it (Jim maybe?) could take care
> >> of it.  If not, then I can always make an attempt using dummy_hcd to
> >> test it.
> > I can create a patch for the host driver, I will issue the gadget patch
> > first to resolve any issues, the fix would be similar.
> 
> Well, I couldn't help myself.  I just had to test it.  The attached
> patch works for me, briefly tested with an Ericsson H5321gw NCM device.
> I have no ideas about the performance impact as that modem is limited to
> 21 Mbps HSDPA.

Ideally, the skb_in should not be freed/reallocated, but recycled,
especially if using 32KB.

But thats a minor detail, this patch is already a huge win for a 21Mbps
device.

Acked-by: Eric Dumazet <edumazet@google.com>


