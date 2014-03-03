Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaCCMVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 07:21:04 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48690 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbaCCMVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 07:21:03 -0500
Date: Mon, 3 Mar 2014 12:20:29 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "David E. Box" <david.e.box@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 1/2] x86: IOSF: add dummy functions for loadable
 modules
Message-ID: <20140303122029.2c4e767c@alan.etchedpixels.co.uk>
In-Reply-To: <53142D84.8010506@linux.intel.com>
References: <1393641652-7222-1-git-send-email-david.e.box@linux.intel.com>
	<1393641652-7222-2-git-send-email-david.e.box@linux.intel.com>
	<53142D84.8010506@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Mar 2014 15:21:40 +0800
"Li, Aubrey" <aubrey.li@linux.intel.com> wrote:

> On 2014/3/1 10:40, David E. Box wrote:
> > From: "David E. Box" <david.e.box@linux.intel.com>
> > 
> > Some loadable modules only need IOSF access on the platforms where it exists.
> > Provide dummy functions to allow these modules to compile and load on the
> > platforms where it doesn't exist.
> 
> This is not the right way, I think.

Disagree. There are various drivers that can use the IOSF interface but
do not need it, and need to also build and run on platforms without it.

The current code IMHO is correct. We want to make sure it builds without
IOSF, but that any attempt to use IOSF in such a runtime errors - that's
what this code does.

Alan
