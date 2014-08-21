Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaHUQ0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:26:03 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:59553 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaHUQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:26:01 -0400
Date: Thu, 21 Aug 2014 18:25:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/9] Mark literal strings in __init / __exit code
Message-ID: <20140821162554.GA884@ravnborg.org>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 02:23:03PM +0200, Mathias Krause wrote:
> This is v3 of the patch series initially posted here:
> 
>   https://lkml.org/lkml/2014/6/22/149
> 
> This series tries to address the problem of dangling strings of __init
> functions after initialization, as well as __exit strings for code not
> even included in the final kernel image. The code might get freed, but
> the format strings are not, as they're in the wrong section.

What potential are we looking at here?
Anything less than a page in size would likely not matter as this
is the granularity we look into.
And the code needs to be built-in - which most drivers are not.

So is it really worth it?

The places that already moves the string to __init/__exit should maybe
be droopped to avoid the complication.

	Sam
