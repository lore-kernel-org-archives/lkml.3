Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaBXBge (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:36:34 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46362 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaBXBgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:36:33 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 24 Feb 2014 01:32:54 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Hurley <peter@hurleysoftware.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: memory-barriers.txt again (was Re: [PATCH 4/9] firewire: don't
 use PREPARE_DELAYED_WORK)
Message-ID: <20140224013254.5004c4fb@stein>
In-Reply-To: <20140223235012.GB8264@linux.vnet.ibm.com>
References: <5307849A.9050209@hurleysoftware.com>
	<20140221165730.GA10929@htj.dyndns.org>
	<5307DAC9.2020103@hurleysoftware.com>
	<1393094608.11497.1.camel@dabdike.int.hansenpartnership.com>
	<5308F0E2.3030804@hurleysoftware.com>
	<1393095138.11497.5.camel@dabdike.int.hansenpartnership.com>
	<5308F48C.8080609@hurleysoftware.com>
	<20140223022303.3240093c@stein>
	<20140223163743.GU4250@linux.vnet.ibm.com>
	<530A5B93.7010304@hurleysoftware.com>
	<20140223235012.GB8264@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 23 Paul E. McKenney wrote:
>>> Please see below for a patch against the current version of
>>> Documentation/memory-barriers.txt.  Does this update help?

Thank you, this clarifies it.

[...]
A new nit:
> +The operations will always occur in one of the following orders:
>  
> -	STORE *A, RELEASE, ACQUIRE, STORE *B
> -	STORE *A, ACQUIRE, RELEASE, STORE *B
> +	STORE *A, RELEASE, ACQUIRE, smp_mb__after_unlock_lock(), STORE *B
> +	STORE *A, ACQUIRE, RELEASE, smp_mb__after_unlock_lock(), STORE *B
> +	ACQUIRE, STORE *A, RELEASE, smp_mb__after_unlock_lock(), STORE *B
>  
> -If the RELEASE and ACQUIRE were instead both operating on the same lock
> -variable, only the first of these two alternatives can occur.
> +If the RELEASE and ACQUIRE were instead both operating on the
> +same lock variable, only the first of these two alternatives can
> +occur.
                                               ^^^
...these {,three} alternatives...
-- 
Stefan Richter
-=====-====- --=- ==---
http://arcgraph.de/sr/
