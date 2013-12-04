Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3LDM7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:59:12 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:48878 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3LDM7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:59:11 -0500
Date: Wed, 4 Dec 2013 09:59:04 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] perf diff: color the Ratio column
Message-ID: <20131204125904.GB6359@ghostprotocols.net>
References: <1385732192-27713-1-git-send-email-artagnon@gmail.com>
 <1385732192-27713-3-git-send-email-artagnon@gmail.com>
 <20131201195634.GB1215@krava.brq.redhat.com>
 <20131202193502.GA3706@infradead.org>
 <CALkWK0nBDqHSWxCVYtU5NMZ4J4=DHGXqk0ZHzM2z8rS1ohjwRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0nBDqHSWxCVYtU5NMZ4J4=DHGXqk0ZHzM2z8rS1ohjwRw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 04, 2013 at 03:40:25PM +0530, Ramkumar Ramachandra escreveu:
> Arnaldo Carvalho de Melo wrote:
> > static inline percent_color_snprintf(...)
> > {
> >         return value_color_snprintf(...);
> > }
> 
> The issue with this suggestion is that the prototype of
> percent_color_snprintf() is:
> 
>   int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...)
> 
> So, I can only pass value_color_snprintf() a va_list, making its prototype:
> 
>   int value_color_snprintf(char *bf, size_t size, const char *fmt, va_list args)
> 
> Is this worth the minor rename?

That is ok, I'd say. Or if that would be a problem one could consider
using a macro, perhaps.
 
> On a related note, does percent_color_snprintf() need to be a variadic
> function? It only seems to process one percent value.

I think that there are places where it is passed as a pointer that
expects it to have that prototype, this is from memory, so please check.

- Arnaldo
