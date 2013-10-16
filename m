Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352Ab3JPXV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:21:29 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53110 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3JPXV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:21:27 -0400
Message-ID: <1381965672.17841.71.camel@pasglop>
Subject: Re: [PATCH 1/2] tty/hvc_console: Add DTR/RTS callback to handle
 HUPCL control
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, brueckner@linux.vnet.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Wed, 16 Oct 2013 18:21:12 -0500
In-Reply-To: <20131016090432.GA6053@linux.vnet.ibm.com>
References: <1372777635-10423-1-git-send-email-brueckner@linux.vnet.ibm.com>
	 <1372777635-10423-2-git-send-email-brueckner@linux.vnet.ibm.com>
	 <1381475711.5630.67.camel@pasglop>
	 <20131011124707.GA6082@linux.vnet.ibm.com>
	 <1381524204.5630.91.camel@pasglop>
	 <20131015153626.GA6129@linux.vnet.ibm.com>
	 <1381870070.17841.24.camel@pasglop>
	 <20131016090432.GA6053@linux.vnet.ibm.com>
Organization: IBM Australia
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101623-5490-0000-0000-00000455102F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 11:04 +0200, Hendrik Brueckner wrote:
> Indeed, two callbacks change the DTR line.  The main difference is that
> tiocmget/tiocmset can be called from user space by ioctl.  That's not the case
> for the dtr_cts callback.  Also, tiocmget/tiocmset provide more flags that can
> be changed (ST, SR, CTS, CD, RNG, RI,  ...)
> 
> Assume we would like to unify them have a single callback to change DTR, then
> we have to take care of these differences.  So the question to you now is
> whether you plan for a) other modem flags to be changed and b) if changing the
> DTR line (or other control flags) through an ioctl?
> 
> Depending on your results, I could work on sth that helps us both and reduces
> the callbacks.

Can we not just have the users of dtr_cts just call the backend's tiocmset ?

If they need to filter or clamp bits, we could handle all that in hvc_console
by caching the user intended value and passing a cooked value down to the backend..

None of that is urgent or anything, it's just odd and would be nice to cleanup.

Cheers,
Ben.


