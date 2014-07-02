Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbaGBTiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:38:08 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49889 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbaGBTiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:38:06 -0400
Message-ID: <1404329880.596.92.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v2 1/3] ima: use ahash API for file hash calculation
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Date: Wed, 02 Jul 2014 15:38:00 -0400
In-Reply-To: <CACE9dm8vx9b-n4b+0NAvp=9Er4uPWGwa8eYSGtkiAPv5ahve4A@mail.gmail.com>
References: <cover.1404245510.git.d.kasatkin@samsung.com>
	 <72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>
	 <1404323065.596.65.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm8vx9b-n4b+0NAvp=9Er4uPWGwa8eYSGtkiAPv5ahve4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070219-9332-0000-0000-00000143C0A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 21:21 +0300, Dmitry Kasatkin wrote: 
> On 2 July 2014 20:44, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Tue, 2014-07-01 at 23:12 +0300, Dmitry Kasatkin wrote:
> >
> >> -/*
> >> - * Calculate the MD5/SHA1 file digest
> >> - */
> >> +static struct crypto_ahash *ima_alloc_atfm(enum hash_algo algo)
> >> +{
> >> +     struct crypto_ahash *tfm = ima_ahash_tfm;
> >> +     int rc;
> >> +
> >> +     if ((algo != ima_hash_algo && algo < HASH_ALGO__LAST) || !tfm) {
> >> +             tfm = crypto_alloc_ahash(hash_algo_name[algo], 0, 0);
> >
> > In the case where algo isn't the same as ima_hash_algo, won't this
> > replace the existing ima_ahash_tfm without freeing it?
> >
> 
> Look to next comment...

Yep, my mistake in reading the code.

Mimi

