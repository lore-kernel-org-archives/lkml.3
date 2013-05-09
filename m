Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3EIRMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:12:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16759 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3EIRMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:12:17 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=S3IMcBWtOxoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=v5zTX_QIMkQA:10 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=DKq56BpVKz7YDvQEN2IA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368119535.7373.125.camel@gandalf.local.home>
Subject: Re: [PATCH 03/11] ftrace: Cleanup regex_lock and ftrace_lock around
 hash updating
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 13:12:15 -0400
In-Reply-To: <20130509054421.30398.83411.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
	 <20130509054421.30398.83411.stgit@mhiramat-M0-7522>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 14:44 +0900, Masami Hiramatsu wrote:
> Cleanup regex_lock and ftrace_lock locking points around
> ftrace_ops hash update code.
> 
> The new rule is that regex_lock protects ops->*_hash
> read-update-write code for each ftrace_ops. Usually,
> hash update is done by following sequence.
> 
> 1. allocate a new local hash and copy the original hash.
> 2. update the local hash.
> 3. move(actually, copy) back the local hash to ftrace_ops.
> 4. update ftrace entries if needed.
> 5. release the local hash.
> 
> This makes regex_lock to protect #1-#4, and ftrace_lock
> to protect #3 and #4.

Patch looks good, but I don't see how ftrace_lock protects #3. The two
things that I see ftrace_lock protecting is the update to the ftrace
entries, and the adding and removing ftrace_ops to the ftrace_ops_list.

-- Steve

> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Tom Zanussi <tom.zanussi@intel.com>
> ---


