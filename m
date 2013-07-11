Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab3GKIAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:00:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51648 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3GKIAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:00:37 -0400
X-AuditID: 9c930179-b7c49ae000000e68-19-51de6624a24b
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/19] perf ftrace: Add 'record' sub-command
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
	<1372230862-15861-10-git-send-email-namhyung@kernel.org>
	<20130710142821.GC5931@krava.brq.redhat.com>
Date: Thu, 11 Jul 2013 17:00:36 +0900
In-Reply-To: <20130710142821.GC5931@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 10 Jul 2013 16:28:21 +0200")
Message-ID: <87bo69y197.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013 16:28:21 +0200, Jiri Olsa wrote:
> On Wed, Jun 26, 2013 at 04:14:12PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>
> SNIP
>
>> +
>> +static int create_perf_directory(struct perf_ftrace *ftrace)
>> +{
>> +	int err;
>> +	char buf[PATH_MAX];
>> +	struct stat statbuf;
>> +
>> +	scnprintf(buf, sizeof(buf), "%s.dir", ftrace->dirname);
>> +
>> +	if (stat(buf, &statbuf) == 0) {
>> +		/* same name already exists - rename to *.old.dir */
>> +		char *old_name = malloc(strlen(buf) + 5);
>> +		if (old_name == NULL)
>> +			return -1;
>> +
>> +		scnprintf(old_name, strlen(buf) + 5,
>> +			  "%s.old.dir", ftrace->dirname);
>> +
>> +		if (remove_directory(old_name) < 0) {
>> +			perror("rmdir");
>> +			return -1;
>> +		}
>> +
>> +		if (rename(buf, old_name) < 0) {
>> +			perror("rename");
>> +			free(old_name);
>> +			return -1;
>> +		}
>> +
>> +		free(old_name);
>> +	}
>> +
>> +	err = mkdir(buf, 0755);
>> +	if (err < 0) {
>> +		perror("mkdir");
>> +		return -1;
>> +	}
>> +
>> +	strcat(buf, "/perf.header");
>> +
>> +	err = open(buf, O_RDWR | O_CREAT | O_TRUNC, 0644);
>> +	return err;
>> +}
>
> nitpick.. should this be rather be called create_perf_header,
> which calls create_perf_directory inside?

Looks reasonable.  I'll change the name.

Thanks,
Namhyung
