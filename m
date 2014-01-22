Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaAVHZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 02:25:35 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:57648 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaAVHZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 02:25:31 -0500
Message-ID: <1390375658.5567.917.camel@haakon3.risingtidesystems.com>
Subject: Re: linux rdma 3.14 merge plans
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Roland Dreier <roland@kernel.org>
Cc: Or Gerlitz <or.gerlitz@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hefty Sean <sean.hefty@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        target-devel <target-devel@vger.kernel.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jan 2014 23:27:38 -0800
In-Reply-To: <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
	 <CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
	 <52CD1C68.4050406@mellanox.com>
	 <1389645171.5567.459.camel@haakon3.risingtidesystems.com>
	 <1389820541.5567.543.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
	 <1389906852.5567.668.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>
	 <1390102949.5567.749.camel@haakon3.risingtidesystems.com>
	 <52DBB4F1.4020400@mellanox.com>
	 <CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>
	 <CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>
	 <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland & Co,

On Tue, 2014-01-21 at 16:43 -0800, Roland Dreier wrote:
> On Tue, Jan 21, 2014 at 2:00 PM, Or Gerlitz <or.gerlitz@gmail.com> wrote:
> > Roland, ping! the signature patches were posted > three months ago. We
> > deserve a response from the maintainer that goes beyond "I need to
> > think on that".
> >
> > Responsiveness was stated by Linus to be the #1 requirement from
> > kernel maintainers.
> 
> Or, I'm not sure what response you're after from me.  Linus has also
> said that maintainers should say "no" a lot more
> (http://lwn.net/Articles/571995/) so maybe you want me to say, "No, I
> won't merge this patch set, since it adds a bunch of complexity to
> support a feature no one really cares about."  Is that it? 

The patch set proposed by Sagi + Or is modest in terms of LOC to core IB
code, and includes mostly mlx5 specific driver changes that enables HW
offloads.

> (And yes I
> am skeptical about this stuff — I work at an enterprise storage
> company and even here it's hard to find anyone who cares about
> DIF/DIX, especially offload features that stop it from being
> end-to-end)
> 

My understanding is most HBAs capable of T10 PI offload in DIX PASS +
VERIFY mode are already implementing DIX INSERT + STRIP modes in various
capacities to support legacy environments.

Beyond the DIX INSERT + STRIP case for enterprise storage, the amount of
FC + SAS HBAs that already support T10 PI metadata is substantial.

> I'm sure you're not expecting me to say, "Sure, I'll merge it without
> understanding the problem it's solving or how it's doing that,"
> especially given the your recent history of pushing me to merge stuff
> like the IP-RoCE patches back when they broke the userspace ABI.

With the merge window now upon us, there is a understandable reluctance
to merge new features.  Given the amount of time the series has spent on
the list, it is however a good candidate to consider for an exception.

Short of that, are you planning to accept the series for the next round
once the current merge window closes..?

We'd really like to start enabling fabrics with these types of offloads
for v3.15. 

> I'd really rather spend my time on something actually useful like
> cleaning up softroce.
> 

+1 for softroce + T10 PI support!

--nab

