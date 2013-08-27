Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab3H0URW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:17:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29811 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3H0URV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:17:21 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=7p2ErawryrAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=65ulK5L86BMA:10 a=QyXUC8HyAAAA:8 a=cxfEerseVHsqx6nTsVkA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 27 Aug 2013 16:17:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 02/10] tracing: add basic event trigger framework
Message-ID: <20130827161720.37d81839@gandalf.local.home>
In-Reply-To: <efa194f41ca2bb52d355060d5109606aaf733315.1377631572.git.tom.zanussi@linux.intel.com>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
	<efa194f41ca2bb52d355060d5109606aaf733315.1377631572.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 14:40:14 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

> +
> +	if (copy_from_user(buf, ubuf, cnt)) {
> +		free_page((unsigned long) buf);
> +		return -EFAULT;
> +	}
> +	buf[cnt] = '\0';
> +	strim(buf);
> +
> +	mutex_lock(&event_mutex);
> +	event_file = event_file_data(file);
> +	if (unlikely(!event_file)) {
> +		mutex_unlock(&event_mutex);
> +		free_page((unsigned long) buf);

Nitpick... Nuke the space before "buf".

-- Steve

> +		return -ENODEV;
> +	}
> +	ret = trigger_process_regex(event_file, buf, enable);
> +	mutex_unlock(&event_mutex);
> +
> +	free_page((unsigned long) buf);
> +	if (ret < 0)
> +		goto out;
