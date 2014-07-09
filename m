Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaGIVIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:08:51 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:43800 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaGIVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:08:48 -0400
X-Auth-Info: PH2CjliWt1CZSVLHDon6nxhWD93R5LiFuWmVuN49sUg=
From: Marek Vasut <marex@denx.de>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: Re: [PATCH v3 1/3] ima: use ahash API for file hash calculation
Date: Wed, 9 Jul 2014 23:00:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmitry.kasatkin@gmail.com
References: <cover.1404475462.git.d.kasatkin@samsung.com> <1404750875.3029.79.camel@dhcp-9-2-203-236.watson.ibm.com> <53BBA6B4.7030705@samsung.com>
In-Reply-To: <53BBA6B4.7030705@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407092300.25224.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 08, 2014 at 10:07:16 AM, Dmitry Kasatkin wrote:
[...]
> > Right, but my concern is not about unloading the kernel module, but
> > about the IMA module parameters left initialized.  The existing code
> > will continue using ahash (software version), even though the kernel
> > module was unloaded, not shash.  My question is about the software
> > implementations of ahash vs. shash performance.
> > 
> > Mimi
> 
> If HW driver will not be available, ahash loads generic driver which is
> using shash.
> Performance of that will be the same as for using shash directly.

Hi Dmitry, I think Mimi is concerned about the crypto accelerator dying mid-
flight.

Imagine a situation where you have a hardware crypto accelerator connected via 
USB. You happily use IMA with this setup for days and then someone comes around 
and pulls the USB cable out. Will this be able to cope with such situation, for 
example by switching to software operations or such in some sane way ?

I presume that's the concern here.

Best regards,
Marek Vasut
