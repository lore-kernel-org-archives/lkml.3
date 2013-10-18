Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab3JRBa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:30:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:28230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab3JRBaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:30:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,518,1378882800"; 
   d="scan'208";a="418709601"
Subject: Re: [PATCH] n_gsm: race between ld close and gsmtty open
From: channing <chao.bi@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20131017171441.GA27850@kroah.com>
References: <1381980550.19582.8.camel@bichao>
	 <20131017171441.GA27850@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Oct 2013 09:59:23 +0800
Message-ID: <1382061563.19582.23.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-17 at 10:14 -0700, Greg KH wrote:
> On Thu, Oct 17, 2013 at 11:29:10AM +0800, channing wrote:
> > 
> > ttyA has ld associated to n_gsm, when ttyA is closing, it triggers
> > to release gsmttyB's ld data dlci[B], then race would happen if gsmttyB
> > is opening in parallel.
> > 
> > Here are some of race cases we found recently in test:
> 
> Are these still an issue with 3.12-rc4?  Lots of pty rework has gone
> into there that should help to resolve some of these problems.
> 

Hi Greg,
I viewed 3.12-rc4 and IMHO it still has this issue, Please correct me if I'm wrong.
This patch was based on 3.12-rc4, following is version info of my code base:

linux/Makefile:
VERSION = 3
PATCHLEVEL = 12
SUBLEVEL = 0
EXTRAVERSION = -rc4

And this version of patch has one line not correct, I updated it in another mail 
with title "[PATCH v2]n_gsm:...", would you please check?

thanks a lot,
chao

