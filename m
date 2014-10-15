Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaJOWPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 18:15:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaJOWPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 18:15:17 -0400
Date: Wed, 15 Oct 2014 15:15:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>, Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib: string.c:  Added a funktion function strzcpy
Message-Id: <20141015151511.ea81b39adcee0954518bf5f3@linux-foundation.org>
In-Reply-To: <1412514377-19387-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1412514377-19387-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<1412514377-19387-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  5 Oct 2014 15:06:17 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:

> Added a function strzcpy which works the same as strncpy,
> but guaranteed to produce the trailing null character.
> 
> There are many places in the code where strncpy used although it
> must be zero terminated, and switching to strlcpy is not an option
> because the string must nonetheless be fyld with zero characters.

As I mentioned last time, I think this patch would be better if it came
with follow-on patches which convert at least some of those callsites. 
As it stands, this function has no callers and hence it won't get
tested.  Plus those follow-on patches will demonstrate the value of
this patch and will provide example usages.
