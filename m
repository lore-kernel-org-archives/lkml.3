Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3KZDFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:05:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:27305 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab3KZDFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:05:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,771,1378882800"; 
   d="scan'208";a="439833080"
Subject: Re: [PATCH V2] n_gsm: race between ld close and gsmtty open
From: channing <chao.bi@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
In-Reply-To: <20131126025432.GA3379@kroah.com>
References: <1385435645.7741.28.camel@bichao>
	 <20131126025432.GA3379@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Nov 2013 11:35:14 +0800
Message-ID: <1385436914.7741.40.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 18:54 -0800, Greg KH wrote:
> On Tue, Nov 26, 2013 at 11:14:05AM +0800, channing wrote:

> > This patch is try to avoid it by:
> > 
> > 1) in n_gsm driver, use a global gsm mutex lock to avoid gsm_dlci_release() run in
> > parallel with gsmtty_install();
The commit is updated here than formal patch set: we use mutex lock in
patch V2, while use spin lock in patch V1.

> > 
> > 2) Increase dlci's ref count in gsmtty_install() instead of in gsmtty_open(), the
> > purpose is to prevent gsm_dlci_release() releasing dlci after gsmtty_install()
> > allocats dlci but before gsmtty_open increases dlci's ref count;
> > 
> > 3) Decrease dlci's ref count in gsmtty_remove(), a tty framework API, this is the
> > opposite process of step 2).
> > 
> > Signed-off-by: Chao Bi <chao.bi@intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I have not signed off on this additional patch.
> 
> What is different from the previous version?  That information needs to
> be somewhere, otherwise I'm just going to guess and say this is the same
> as your last one, which was incorrect.
The difference with previous one is to use a mutex instead of spin lock
to avoid race, purpose is to avoid sleep in atomic context. I've also
updated commit a little as above.

> 
> Also, please fix your "From:" line in your email client to match your
> Signed-off-by: line, or else add the proper "From:" line to your patch,
> as the Documentation/SubmittingPatches file says.
> 
> Care to try again?
Yes, I'll correct it. thanks.
> 
> greg k-h


