Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3ILMcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:32:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab3ILMcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:32:19 -0400
Date: Thu, 12 Sep 2013 14:31:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf tools: Separate out GTK codes to libperf-gtk.so
Message-ID: <20130912123156.GA15187@krava.brq.redhat.com>
References: <1378967659-30104-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378967659-30104-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 03:34:19PM +0900, Namhyung Kim wrote:
> Separate out GTK codes to a shared object called libperf-gtk.so.  This

SNIP

>  pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
> +void *perf_gtk_handle;
> +
> +#ifdef GTK2_SUPPORT
> +static int setup_gtk_browser(void)
> +{
> +	int (*perf_ui_init)(void);
> +
> +	if (perf_gtk_handle)
> +		return 0;
> +
> +	perf_gtk_handle = dlopen("libperf-gtk.so", RTLD_LAZY);
> +	if (perf_gtk_handle == NULL)
> +		return -1;

shouldn't we try for known installed path here?

  $ perf report --gtk
  GTK browser requested but could not find libperf-gtk.so

otherwise I need to do some ld.conf setup or run it like this:

  LD_LIBRARY_PATH=/home/jolsa/lib64/ ./perf report --gtk
  LD_LIBRARY_PATH=./ ./perf report --gtk

jirka
