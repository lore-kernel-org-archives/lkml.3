Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaA3Pvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:51:41 -0500
Received: from www84.your-server.de ([213.133.104.84]:48006 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaA3Pvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:51:39 -0500
Message-ID: <1391097131.2898.5.camel@wall-e.seibold.net>
Subject: Re: [PATCH 0/4] Add 32 bit VDSO time function support
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Thu, 30 Jan 2014 16:52:11 +0100
In-Reply-To: <52EA704D.2000809@zytor.com>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
	 <52EA704D.2000809@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 30.01.2014, 07:31 -0800 schrieb H. Peter Anvin:
> On 01/30/2014 02:49 AM, stefani@seibold.net wrote:
> > The VDSO page for a 32 bit resided now on 0xffffc000, followed by the VVAR and
> > HPET page.
> 
> Any reason to not move the vdso base page to the top, in order to avoid
> breaking broken applications?  It seems a fairly innocuous shuffle...
> probably little gain, but very little cost.
> 
> 	-hpa
> 

The reason is that i get need than an additional VMA for HPET and VVAR. 

I seen no break of applications since the __FIXADDR_TOP is not on a fix
place. Lguest, XEN, OPLC and the reservetop Kernel Parameter will change
the VDSO Page Address.

- Stefani

