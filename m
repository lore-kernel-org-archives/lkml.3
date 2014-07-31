Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaGaCkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:40:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:5591 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbaGaCkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:40:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,769,1400050800"; 
   d="scan'208";a="569752071"
Date: Thu, 31 Jul 2014 10:40:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [delayed_fput] BUG: unable to handle kernel paging request at
 ffff8800122a0ad0
Message-ID: <20140731024014.GA10184@localhost>
References: <20140730035541.GD16537@localhost>
 <20140730111521.GB759@infradead.org>
 <alpine.DEB.2.02.1407301550140.26018@chino.kir.corp.google.com>
 <CAADnVQ+OwgG-RJQ7QwfW2qrvpV9XYySckTbNmcacW7K0KxQqvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+OwgG-RJQ7QwfW2qrvpV9XYySckTbNmcacW7K0KxQqvA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 04:00:58PM -0700, Alexei Starovoitov wrote:
> On Wed, Jul 30, 2014 at 3:51 PM, David Rientjes <rientjes@google.com> wrote:
> > On Wed, 30 Jul 2014, Christoph Hellwig wrote:
> >
> >> On Wed, Jul 30, 2014 at 11:55:41AM +0800, Fengguang Wu wrote:
> >> > Greetings,
> >> >
> >> > 0day kernel testing robot got the below dmesg and the first bad commit is
> >>
> >> How does this manage to trip over a 2 year old commit now?
> 
> may be because all kernels are built with gcc 4.8.2 ?
> Fengguang, did you recently switch to new compiler?
> I think all older builds were with 4.6.3

Alexei, I've been using gcc 4.8.2 for 4 months.

Maybe it's because I test new randconfigs every day. And the problem
may only show up with very specific kernel config?

Thanks,
Fengguang

> > I think there's something weird going on with the testing of CONFIG_SLOB,
> > same as http://permalink.gmane.org/gmane.linux.kernel/1759314 that
> > identified a harmless commit that only initializes a field of
> > struct mm_struct and then ended up exploded in slob freeing.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
