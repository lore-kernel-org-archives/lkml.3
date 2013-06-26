Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3FZO7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:59:02 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:42307 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3FZO7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:59:00 -0400
Date: Wed, 26 Jun 2013 11:58:53 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: perf tools: Introduce new -P/--parent-deep report option
Message-ID: <20130626145853.GA2309@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

	About the patch below, can't this be solved by using a regex
instead of a simple substring search instead of adding a new command
line option?

- Arnaldo

commit 5b42ff035ec784c5c42c4a6bb9e7fada882f097e
Author: Jiri Olsa <jolsa@redhat.com>
Date:   Tue Jun 18 18:31:50 2013 +0200

    perf tools: Introduce new -P/--parent-deep report option
    
    Introducing new -P/--parent-deep report option. It does the
    same as '-p' but it force the deep search of the callchain
    and looks for the deepest possible match.
    
    The -p option searches for the first match of the parent
    pattern in the callchain.
    
      $ perf report -i perf.data.delete -p perf_session__delete -s parent
    
      +  99.51%  [other]
      +   0.46%  perf_session__delete_dead_threads
      +   0.03%  perf_session__delete
      +   0.00%  perf_session__delete_threads
    
    so we got multiple 'different' matches instancies, while
    they all belong under perf_session__delete function:
    
      $ perf report -i perf.data.delete -P perf_session__delete -s parent
    
      +  99.51%  [other]
      +   0.49%  perf_session__delete
    
    NOTE the 'p' vs 'P' difference in above commands above.

