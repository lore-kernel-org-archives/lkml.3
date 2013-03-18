Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3CRM7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:59:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48189 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3CRM7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:59:45 -0400
Message-ID: <1363611569.22553.10.camel@laptop>
Subject: Re: [PATCH] perf: fix ring_buffer perf_output_space() boundary
 calculation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jolsa@redhat.com,
        fweisbec@gmail.com
Date: Mon, 18 Mar 2013 13:59:29 +0100
In-Reply-To: <20130318124847.GA2491@quad>
References: <20130318124847.GA2491@quad>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 13:48 +0100, Stephane Eranian wrote:
>         if (!rb->writable)
> -               return true;
> +               return false;


writable means user writable (VM_WRITE); the difference is that a
!VM_WRITE buffer will simply over-write its own tail whereas a VM_WRITE
buffer will drop events.

So returning true for !VM_WRITE makes sense, there's always space.

