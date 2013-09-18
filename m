Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3IRIfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:35:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54558 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3IRIfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:35:51 -0400
Date: Wed, 18 Sep 2013 09:35:46 +0100
From: Javi Merino <javi.merino@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smp: harmonize prototypes of smp functions
Message-ID: <20130918083546.GA2976@e102654-lin.cambridge.arm.com>
References: <1378132393-17089-1-git-send-email-javi.merino@arm.com>
 <20130917142228.0cb08371ea5259ca53055fe4@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20130917142228.0cb08371ea5259ca53055fe4@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 18 Sep 2013 08:35:47.0289 (UTC) FILETIME=[12988C90:01CEB44A]
X-MC-Unique: 113091809354901501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 10:22:28PM +0100, Andrew Morton wrote:
> On Mon,  2 Sep 2013 15:33:13 +0100 Javi Merino <javi.merino@arm.com> wrote:
> 
> > Avoid unnecessary casts from int to bool in smp functions.  Some
> > functions in kernel/smp.c have a wait parameter that can be set to one
> > if you want to wait for the command to complete.  It's defined as bool
> > in a few of them and int in the rest.  If a function with wait
> > declared as int calls a function whose prototype has wait defined as
> > bool, the compiler needs to test if the int is != 0 and change it to 1
> > if so.  This useless check can be avoided if we are consistent and
> > make all the functions use the same type for this parameter.
> 
> Yes, that's a problem with bool.
> 
> But the `wait' argument *is* a boolean and switching everything over to
> use "bool" (instead of "int") should provide similar code-size savings.
> Did you evaluate that approach?

I did; you get exactly the same code-size savings.  But then I read
this[0] and thought that "int" was preferred.

[0] https://lkml.org/lkml/2013/8/31/138

I can submit the "bool" patch instead if you prefer it.  Cheers,
Javi

