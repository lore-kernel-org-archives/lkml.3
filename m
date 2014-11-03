Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaKCNvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:51:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaKCNvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:51:36 -0500
Date: Mon, 3 Nov 2014 14:51:17 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/8] perf tools: Preparation for compressed kernel module
 support
Message-ID: <20141103135116.GC29906@krava.brq.redhat.com>
References: <1414999678-31377-1-git-send-email-namhyung@kernel.org>
 <1414999678-31377-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414999678-31377-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:27:51PM +0900, Namhyung Kim wrote:

SNIP

> +static int decompress_dummy(const char *input __maybe_unused,
> +			    int output __maybe_unused)
> +{
> +	return -1;
> +}
> +
> +static const struct {
> +	const char *fmt;
> +	int (*decompress)(const char *input, int output);
> +} compressions[] = {
> +	{ "gz", decompress_dummy },
> +};
> +
> +bool is_supported_compression(const char *ext)
> +{
> +	unsigned i;
> +
> +	for (i = 0; i < ARRAY_SIZE(compressions); i++) {
> +		if (!strcmp(ext, compressions[i].fmt))
> +			return true;
> +	}
> +	return false;
> +}
> +
> +bool is_kmodule_extension(const char *ext)
> +{
> +	if (!strcmp(ext, "ko"))
> +		return true;
> +
> +	if (ext[2] == '\0' || (ext[2] == '.' && is_supported_compression(ext+3)))
> +		return true;

I got stuck in here.. so any 2 chars string is kernel module extension?
plus how do u know ext[3] (or [2]) is valid memory?

thanks,
jirka
