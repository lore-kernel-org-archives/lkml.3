Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3EFRs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 13:48:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab3EFRsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 13:48:55 -0400
Date: Mon, 6 May 2013 19:48:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, Ulrich Drepper <drepper@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 5/8] perf tools: Add support to preload default formulas
Message-ID: <20130506174830.GC4562@krava.brq.redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
 <1367421346-18257-6-git-send-email-jolsa@redhat.com>
 <5183D394.8090205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5183D394.8090205@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 09:11:16AM -0600, David Ahern wrote:
> On 5/1/13 9:15 AM, Jiri Olsa wrote:
> >+int perf_formula__load_dir(struct perf_formula *f, char *path)
> >+{
> >+	struct dirent *ent;
> >+	DIR *dir;
> >+	int ret = 0;
> >+
> >+	dir = opendir(path);
> >+	if (!dir) {
> >+		pr_err("formula: can't open dir '%s' - %s\n",
> >+		       path, strerror(errno));
> >+		return -1;
> >+	}
> >+
> >+	while (!ret && (ent = readdir(dir))) {
> >+		char file[PATH_MAX];
> 
> readdir_r? this is going into libperf, so might as well be thread safe.

right, will do

thanks,
jirka
