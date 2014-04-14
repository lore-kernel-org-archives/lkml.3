Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbaDNJqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:46:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaDNJqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:46:48 -0400
Date: Mon, 14 Apr 2014 10:50:28 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, tools: Support spark lines in perf stat
Message-ID: <20140414085028.GA1433@krava.brq.redhat.com>
References: <1395768699-16060-1-git-send-email-andi@firstfloor.org>
 <1395768699-16060-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395768699-16060-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 10:31:39AM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 

SNIP

> @@ -1176,6 +1176,9 @@ static void print_aggr(char *prefix)
>  				if (run != ena)
>  					fprintf(output, "  (%.2f%%)",
>  						100.0 * run / ena);
> +
> +				fputc(' ', output);
> +				print_stat_spark(output, counter->priv);
>  			}
>  			fputc('\n', output);
>  		}
> @@ -1224,6 +1227,9 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
>  
>  	print_noise(counter, avg);
>  
> +	fputc(' ', output);
> +	print_stat_spark(output, counter->priv);
> +
>  	if (csv_output) {
>  		fputc('\n', output);
>  		return;
> @@ -1295,6 +1301,9 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
>  			if (run != ena)
>  				fprintf(output, "  (%.2f%%)",
>  					100.0 * run / ena);
> +
> +			fputc(' ', output);
> +			print_stat_spark(output, counter->priv);
>  		}
>  		fputc('\n', output);
>  	}
> @@ -1355,6 +1364,9 @@ static void print_stat(int argc, const char **argv)
>  			fprintf(output, "                                        ");
>  			print_noise_pct(stddev_stats(&walltime_nsecs_stats),
>  					avg_stats(&walltime_nsecs_stats));
> +
> +			fputc(' ', output);
> +			print_stat_spark(output, &walltime_nsecs_stats);

Do we want to be that explicit about printing ' ' here?
I dont see it elsewhere..

fput could go into print_stat_spark


SNIP

> +void print_stat_spark(FILE *f, struct stats *stat)
> +{
> +	int n = stat->n, len;
> +
> +	if (n <= 1)
> +		return;
> +	len = n;
> +	if (len > NUM_SPARK_VALS)
> +		len = NUM_SPARK_VALS;
> +	if (all_the_same(stat->svals, len))
> +		return;
> +	print_spark(f, stat->svals, len);
> +	if (stat->n > NUM_SPARK_VALS)
> +		fputs("..", f);
> +}

whats the reason for 'n' in here?  looks like you could do only with 'len'

thanks,
jirka
