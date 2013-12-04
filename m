Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3LDKLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:11:11 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36937 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3LDKLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:11:06 -0500
MIME-Version: 1.0
In-Reply-To: <20131202193502.GA3706@infradead.org>
References: <1385732192-27713-1-git-send-email-artagnon@gmail.com>
 <1385732192-27713-3-git-send-email-artagnon@gmail.com> <20131201195634.GB1215@krava.brq.redhat.com>
 <20131202193502.GA3706@infradead.org>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 4 Dec 2013 15:40:25 +0530
Message-ID: <CALkWK0nBDqHSWxCVYtU5NMZ4J4=DHGXqk0ZHzM2z8rS1ohjwRw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] perf diff: color the Ratio column
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> static inline percent_color_snprintf(...)
> {
>         return value_color_snprintf(...);
> }

The issue with this suggestion is that the prototype of
percent_color_snprintf() is:

  int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...)

So, I can only pass value_color_snprintf() a va_list, making its prototype:

  int value_color_snprintf(char *bf, size_t size, const char *fmt, va_list args)

Is this worth the minor rename?

On a related note, does percent_color_snprintf() need to be a variadic
function? It only seems to process one percent value.
