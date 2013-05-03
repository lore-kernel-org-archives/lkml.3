Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593Ab3ECPLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:11:22 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:56044 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab3ECPLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:11:20 -0400
Message-ID: <5183D394.8090205@gmail.com>
Date: Fri, 03 May 2013 09:11:16 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, Ulrich Drepper <drepper@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 5/8] perf tools: Add support to preload default formulas
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com> <1367421346-18257-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/13 9:15 AM, Jiri Olsa wrote:
> +int perf_formula__load_dir(struct perf_formula *f, char *path)
> +{
> +	struct dirent *ent;
> +	DIR *dir;
> +	int ret = 0;
> +
> +	dir = opendir(path);
> +	if (!dir) {
> +		pr_err("formula: can't open dir '%s' - %s\n",
> +		       path, strerror(errno));
> +		return -1;
> +	}
> +
> +	while (!ret && (ent = readdir(dir))) {
> +		char file[PATH_MAX];

readdir_r? this is going into libperf, so might as well be thread safe.

David
