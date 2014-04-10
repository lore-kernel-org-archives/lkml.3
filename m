Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935287AbaDJJby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:31:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbaDJJbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:31:51 -0400
Date: Thu, 10 Apr 2014 11:31:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        namhyung@gmail.com
Subject: Re: [PATCH 1/4 v2] perf: Allow ability to map cpus to nodes easily
Message-ID: <20140410093146.GE1141@krava.brq.redhat.com>
References: <1396896924-129847-1-git-send-email-dzickus@redhat.com>
 <1396896924-129847-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396896924-129847-2-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 02:55:21PM -0400, Don Zickus wrote:

SNIP

> +static int init_cpunode_map(void)
> +{
> +	int i;
> +
> +	set_max_cpu_num();
> +	set_max_node_num();
> +
> +	cpunode_map = calloc(max_cpu_num, sizeof(int));
> +	if (!cpunode_map) {
> +		pr_err("%s: calloc failed\n", __func__);
> +		goto out;
shuld probably be ^^^:

		return -1;

> +	}
> +
> +	for (i = 0; i < max_cpu_num; i++)
> +		cpunode_map[i] = -1;
> +
> +	return 0;
> +out:
> +	return -1;

and remove 'out' label code

other than that, it seems ok.. I'll queue it

thanks,
jirka
