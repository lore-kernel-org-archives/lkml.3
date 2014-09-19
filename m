Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaISJ43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:56:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36942 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbaISJ41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:56:27 -0400
X-Sasl-enc: 5z468J6JyH/O9ObGdLWq8dtC01BibpHVNP4AzjkVEtE6 1411120586
Date: Fri, 19 Sep 2014 06:56:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140919095613.GB29639@khazad-dum.debian.net>
References: <20140918135202.GA26038@khazad-dum.debian.net>
 <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918145328.0253f009@as>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Chuck Ebbert wrote:
> > > [1] sig 0x000306f2, pf mask 0x6f, 2014-09-03, rev 0x0029, size 28672
> > >     sig 0x000306c3, pf mask 0x32, 2014-07-03, rev 0x001c, size 21504
> > >     sig 0x00040651, pf mask 0x72, 2014-07-03, rev 0x001c, size 20480
> > >     sig 0x00040661, pf mask 0x32, 2014-07-03, rev 0x0012, size 23552

...

> > Given that there is exactly one microcode update like this (at least of
> > the sort that blows up userspace), I think that we should seriously
> > consider blacklisting just this particular microcode update once
> > userspace is running.
> > 
> 
> All future updates for these CPUs will have this problem.

Sort of.  Any update _from_ microcodes earlier than the above, will.

Otherwise, it depends on whether Intel TSX "testing mode" is enabled in
BIOS, and whether it "sticks" across a microcode update or gets reset to the
default of "disabled".  Updating from "disabled" to "disabled" should be
safe.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
