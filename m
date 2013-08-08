Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3HHFyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:54:25 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41841 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab3HHFyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:54:24 -0400
Message-ID: <5203328C.6040706@hitachi.com>
Date: Thu, 08 Aug 2013 14:54:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/11] tracing: add 'enable_event' and 'disable_event'
 event trigger commands
References: <cover.1375111640.git.tom.zanussi@linux.intel.com> <bf0caa30e9bd252e3712d4d677f5787641fc1c54.1375111640.git.tom.zanussi@linux.intel.com>
In-Reply-To: <bf0caa30e9bd252e3712d4d677f5787641fc1c54.1375111640.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/30 1:41), Tom Zanussi wrote:
> +
> +static int
> +event_enable_trigger_func(struct event_command *cmd_ops, void *cmd_data,
> +			  char *glob, char *cmd, char *param, int enabled)
> +{
> +	struct trace_array *tr = top_trace_array();

OK, here is the problem. top_trace_array() always returns the default
instance. So, following change will solve the problem.

	struct trigger_iterator *iter = cmd_data;
	struct trace_array *tr = iter->file->tr;

However, I think we still have a race problem on accessing event_file.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


