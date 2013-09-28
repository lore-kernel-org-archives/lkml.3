Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3I1DGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 23:06:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:60640 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab3I1DGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 23:06:18 -0400
Message-ID: <1380337550.27811.71.camel@pasglop>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sat, 28 Sep 2013 13:05:50 +1000
In-Reply-To: <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
References: <1380270519.27811.10.camel@pasglop>
	 <CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
	 <CA+55aFyDfMdAeaniQwkoeW6F-xd3JxrzGYwtFb6N9+NA6aRCMg@mail.gmail.com>
	 <1380318405.27811.37.camel@pasglop>
	 <CAE9FiQXXvkfTak6oEpUog_RYs_Gwpdji7N5UJ=R11Q61==N97A@mail.gmail.com>
	 <1380321480.27811.53.camel@pasglop>
	 <CAE9FiQWm7ALPO5k_2nV+fuZw4oNNiw+_PEx8EWkb52ymN+EYUg@mail.gmail.com>
	 <1380323960.27811.67.camel@pasglop>
	 <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 16:44 -0700, Yinghai Lu wrote:

> > Thus the port driver bails out before calling pci_set_master(). The fix
> > is to call pci_set_master() unconditionally. However that lead me to
> > find to a few interesting oddities in that port driver code:
> 
> can we revert that partially change ? aka we should check get_port....
> at first...
> 
> like attached.

In the meantime, can you properly submit the other one with the warning
to Linus ? It will make things more robust overall...

Also, please read my other comments. I think we are treading on very
fragile ground with that whole business of potentially disabling bridges
in the pcieport driver ...

Cheers,
Ben.


