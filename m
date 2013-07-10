Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3GJO7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:59:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59186 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754419Ab3GJO7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:59:44 -0400
Message-ID: <1373468383.14604.41.camel@joe-AO722>
Subject: Re: [PATCH 2/3] firmware/dmi_scan: Fix most checkpatch errors and
 warnings
From: Joe Perches <joe@perches.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 10 Jul 2013 07:59:43 -0700
In-Reply-To: <1373459305.4399.27.camel@chaos.site>
References: <1373384438.4391.6.camel@chaos.site>
	 <1373384574.4391.9.camel@chaos.site>  <1373386794.14604.14.camel@joe-AO722>
	 <1373459305.4399.27.camel@chaos.site>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 14:28 +0200, Jean Delvare wrote:
> Hi Joe,

hi Jean.

> Le Tuesday 09 July 2013 à 09:19 -0700, Joe Perches a écrit :
> > On Tue, 2013-07-09 at 17:42 +0200, Jean Delvare wrote:
[]
> > If the function name is used in every printk, it might
> > be better to add
> > #define pr_fmt(fmt) "%s: " fmt, __func__
[]
> > If not, then I suggest removing the embedded function names
> > and writing these as
> > 		pr_err("%s: etc...", __func__, etc...);
> > This eliminates any possible function name mismatch.
> I had considered this too, but stepped back after finding out that this
> change would increase the binary size. It's hard to sell such a change
> then when it's only fixing a theoretical problem.

No worries.

Another tiny consideration is that __func__ is both
generally not particularly useful and could in the
future be consolidated via vsprintf/printk having
some extension that uses __builtin_return_address
and sprint_symbol_no_offset.

cheers, Joe

