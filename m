Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaL1SNL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 13:13:11 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:43456 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaL1SNF (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 28 Dec 2014 13:13:05 -0500
Message-ID: <1419790377.8667.6.camel@stgolabs.net>
Subject: Re: [PATCH 2/8] locking/mutex: Get rid of use_ww_cxt param in
 common paths
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 28 Dec 2014 10:12:57 -0800
In-Reply-To: <20141228162303.GA12952@dyad.arnhem.chello.nl>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
	 <1419757883-4423-3-git-send-email-dave@stgolabs.net>
	 <20141228162303.GA12952@dyad.arnhem.chello.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-28 at 17:23 +0100, Peter Zijlstra wrote:
> On Sun, Dec 28, 2014 at 01:11:17AM -0800, Davidlohr Bueso wrote:
> > ... and simplify a bit the parameters of __mutex_lock_common(). This
> > is straightforward as we can just check if the ww cxt for NULL if passed
> > from non wait/wound paths.
> 
> 
> The reason for this trainwreck is because of some older GCC not actually doing
> the const propagation of the MULL pointer right.

That's a shame, I really detest all this ww mess.

