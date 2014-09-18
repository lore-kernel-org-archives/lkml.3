Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaIRUCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:02:15 -0400
Received: from gw1.transmode.se ([195.58.98.146]:55854 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145AbaIRUCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:02:14 -0400
In-Reply-To: <541B2E45.5070900@c-s.fr>
References: <20140917163657.7737D1AB032@localhost.localdomain> <OF3CC96BF2.DF7CB060-ONC1257D57.00533ED7-C1257D57.0053CADF@transmode.se> <541B0B66.8030405@c-s.fr> <OFB7DFC74D.65FC1C31-ONC1257D57.00632BC3-C1257D57.00640A0B@transmode.se> <541B2E45.5070900@c-s.fr>
To: christophe leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
MIME-Version: 1.0
Subject: Re: [PATCH v3 03/21] powerpc/8xx: exception InstructionAccess does not
 exist on MPC8xx
X-KeepSent: FF48B453:8913C6B0-C1257D57:006DED24;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OFFF48B453.8913C6B0-ONC1257D57.006DED24-C1257D57.006E0FCC@transmode.se>
Date: Thu, 18 Sep 2014 22:02:09 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 18/09/2014 22:02:10,
	Serialize complete at 18/09/2014 22:02:10
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

christophe leroy <christophe.leroy@c-s.fr> wrote on 2014/09/18 21:11:01:
> 
> 
> Le 18/09/2014 20:12, Joakim Tjernlund a écrit :
> > leroy christophe <christophe.leroy@c-s.fr> wrote on 2014/09/18 
18:42:14:
> >
> >> Le 18/09/2014 17:15, Joakim Tjernlund a écrit :
> >>> Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2014/09/17
> > 18:36:57:
> >>>> Exception InstructionAccess does not exist on MPC8xx. No need to
> > branch
> >>> there from somewhere else.
> >>>> Handling can be done directly in InstructionTLBError Exception.
> >>>>
> >>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >>        . = 0x1200
> >>    DataStoreTLBMiss:
> >> @@ -477,7 +475,11 @@ DataStoreTLBMiss:
> >>     */
> >>        . = 0x1300
> >>    InstructionTLBError:
> >> -    b    InstructionAccess
> >> +    EXCEPTION_PROLOG
> >> +    mr    r4,r12
> >> +    mr    r5,r9
> >> +    /* 0x400 is InstructionAccess exception, needed by 
bad_page_fault()
> > */
> >> +    EXC_XFER_LITE(0x400, handle_page_fault)
> > You should have the code in TLBMiss and have the TLBError branch there 
as
> > that is the common case.
> As far as I remember, I tried it already but we don't have enough space 
> in TLBmiss for that. We can only have 40 instructions.

Do your other optimizations first, then you might have space :)

 Jocke
