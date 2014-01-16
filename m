Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaAPRYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:24:09 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:43123 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAPRYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:24:08 -0500
Date: Thu, 16 Jan 2014 18:24:06 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Christoph Lameter <cl@linux.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Jesse Gross <jesse@nicira.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@redhat.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Jakub Zawadzki <darkjames-ws@darkjames.pl>
Subject: Re: [PATCH net-next 2/2] reciprocal_divide: correction/update of the algorithm
Message-ID: <20140116172406.GA17529@order.stressinduktion.org>
Mail-Followup-To: Christoph Lameter <cl@linux.com>,
	Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Austin S Hemmelgarn <ahferroin7@gmail.com>,
	Jesse Gross <jesse@nicira.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@kernel.org>,
	Andy Gospodarek <andy@greyhouse.net>,
	Veaceslav Falico <vfalico@redhat.com>,
	Jay Vosburgh <fubar@us.ibm.com>,
	Jakub Zawadzki <darkjames-ws@darkjames.pl>
References: <1389828228-30312-1-git-send-email-dborkman@redhat.com> <1389828228-30312-3-git-send-email-dborkman@redhat.com> <alpine.DEB.2.10.1401161036110.29778@nuc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401161036110.29778@nuc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 10:37:37AM -0600, Christoph Lameter wrote:
> On Thu, 16 Jan 2014, Daniel Borkmann wrote:
> 
> > - * or else the performance is slower than a normal divide.
> > - */
> > -extern u32 reciprocal_value(u32 B);
> > +struct reciprocal_value {
> > +	u32 m;
> > +	u8 sh1, sh2;
> > +};
> >
> > +#define RECIPROCAL_VALUE_RESULT_TO_ZERO ((struct reciprocal_value){.sh1 = 32})
> >
> > -static inline u32 reciprocal_divide(u32 A, u32 R)
> > +struct reciprocal_value reciprocal_value(u32 d);
> 
> A function that returns a struct? That works? Which gcc versions support
> it?

Sure, that works and I actually like it. This is supported by the c standard,
but please don't ask me since which one. ;)

Greetings,

  Hannes

