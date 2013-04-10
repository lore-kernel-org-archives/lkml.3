Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936321Ab3DJAq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:46:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3570 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764843Ab3DJAq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:46:28 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=i53ZzN_X_rgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=NxKs5EB5JOMA:10 a=TwWvS8Hdisza_jEdPc4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365554787.25498.88.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] tracing: Check cpu file on tracing_release()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 09 Apr 2013 20:46:27 -0400
In-Reply-To: <5164B3F0.2030506@lge.com>
References: <1365553093-10180-1-git-send-email-namhyung@kernel.org>
	  <1365553093-10180-3-git-send-email-namhyung@kernel.org>
	 <1365553863.25498.84.camel@gandalf.local.home> <5164B3F0.2030506@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 09:36 +0900, Namhyung Kim wrote:

> You meant iter->cpu_file != RING_BUFFER_ALL_CPUS case, right?

Yep.

> 
> So why bother trying to check other cpus then?

Because it's a very slow path (closing a file), and it keeps the code
simpler and more condense.

We could add your change for consistency, but right now, its very low
priority.

But looking at the code, I do see a clean up that looks like it would be
worth updating. If the ring_buffer_read_prepare() fails, we should
probably let the user know, instead of succeeding and then having no
output.

Looks like all users of the buffer_iter[cpu] will fail quietly if it is
NULL, thus it's not a problem with crashing the kernel.

-- Steve


