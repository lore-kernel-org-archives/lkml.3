Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaBSV7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:59:48 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:42449 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaBSV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:59:47 -0500
Date: Wed, 19 Feb 2014 18:59:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 1/6] perf tools: Factor features display code
Message-ID: <20140219215936.GA5982@ghostprotocols.net>
References: <1392825179-5228-1-git-send-email-jolsa@redhat.com>
 <1392825179-5228-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392825179-5228-2-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 19, 2014 at 04:52:54PM +0100, Jiri Olsa escreveu:
> Currently the we display all detected features/libraries
> by following rules:
>  - if one of the features is missing
>  - if it's build from clean tree
> 
> This patch changes changes this behavior in several ways.
> 
> - We no longer display all detected features, only detected
>   libraries are displayed by default:
> 
>   $ make
>     BUILD:   Doing 'make -j4' parallel build
> 
>   Auto-detecting system features:
>   ...                         dwarf: [ on  ]
>   ...                         glibc: [ on  ]
>   ...                          gtk2: [ on  ]
>   ...                      libaudit: [ on  ]
>   ...                        libbfd: [ on  ]
>   ...                        libelf: [ on  ]
>   ...                       libnuma: [ on  ]
>   ...                       libperl: [ on  ]
>   ...                     libpython: [ on  ]
>   ...                      libslang: [ on  ]
>   ...                     libunwind: [ on  ]

I like it, testing now, one suggestion: Since this is just about
libraries, ditch the "lib' prefix, and make the header more
informative, making it look like this:

   Auto-detecting system libraries that enables features:
   ...                         dwarf: [ on  ]
   ...                             c: [ on  ]
   ...                          gtk2: [ on  ]
   ...                         audit: [ on  ]
   ...                           bfd: [ on  ]
   ...                           elf: [ on  ]
   ...                          numa: [ on  ]
   ...                          perl: [ on  ]
   ...                        python: [ on  ]
   ...                         slang: [ on  ]
   ...                        unwind: [ on  ]
 
Also, do we look first for dwarf, then for glibc?

Back to the other patches...

- Arnaldo
