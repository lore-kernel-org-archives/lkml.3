Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbaCSNXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:23:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933771AbaCSNXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:23:07 -0400
Date: Wed, 19 Mar 2014 14:22:59 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 04/19] perf: Allow ability to map cpus to nodes easily
Message-ID: <20140319132259.GA16181@krava.brq.redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393609388-40489-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:42:53PM -0500, Don Zickus wrote:

SNIP

> +
> +/* Determine highest possible node in the system for sparse allocation */
> +static void set_max_node_num(void)
> +{
> +	FILE *fp;
> +	char buf[256];
> +	int num;
> +
> +	/* set up default */
> +	max_node_num = 8;
> +
> +	/* get the highest possible cpu number for a sparse allocation */
> +	fp = fopen("/sys/devices/system/node/possible", "r");
> +	if (!fp)
> +		goto out;
> +
> +	num = fread(&buf, 1, sizeof(buf), fp);
> +	if (!num)
> +		goto out_close;
> +	buf[num] = '\0';
> +
> +	/* start on the right, to find highest node num */
> +	while (--num) {
> +		if ((buf[num] == ',') || (buf[num] == '-')) {
> +			num++;
> +			break;
> +		}
> +	}
> +	if (sscanf(&buf[num], "%d", &max_node_num) < 1)
> +		goto out_close;
> +
> +	max_node_num++;
> +
> +	fclose(fp);
> +	return;

these ^^^ inners should go into single function and be used in 
both set_max_cpu_num and set_max_node_num functions

jirka
