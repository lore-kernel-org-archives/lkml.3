Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108Ab3HSPRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:17:45 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:50066 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3HSPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:17:44 -0400
Date: Mon, 19 Aug 2013 12:17:34 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] perf ui/gtk: Separate out GTK code to a shared
 object (v4)
Message-ID: <20130819151734.GB3053@ghostprotocols.net>
References: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
 <20130819140500.GA3053@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819140500.GA3053@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 19, 2013 at 11:05:00AM -0300, Arnaldo Carvalho de Melo escreveu:
> But I expected that after the first patch 'perf --gtk' would work, and
> it doesn't.
> 
> Now even after I applied the whole series I don't get --gtk to work,
> neither as a non-root nor as root :-\
> 
> Investigating...

Somehow I expected ~/lib64/ was in the ld library path, it was not, duh,
after I added it, and applied all three patches, it works as expected,
so can we:

1. combine the three patches into just one so that we keep the 'perf
report --gtk' bisectable?

2. add a patch to warn the user when '--gtk' is specified but no
   libperf-gtk.so file is found in the loader library path?

- Arnaldo
