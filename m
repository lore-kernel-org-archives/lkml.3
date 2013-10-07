Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3JGPsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3JGPsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:48:37 -0400
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] Perf support to SDT markers
References: <20131007063911.11693.33624.stgit@hemant-fedora>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 07 Oct 2013 11:47:09 -0400
In-Reply-To: <20131007063911.11693.33624.stgit@hemant-fedora> (Hemant Kumar's message of "Mon, 07 Oct 2013 12:16:49 +0530")
Message-ID: <y0m38odytfm.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hemant Kumar <hkshaw@linux.vnet.ibm.com> writes:

> [...]
> A simple example to show this follows.
> - Create a file with .d extension and mention the probe names in it with
> provider name and marker name.
> [...]
> - Now create the probes.h and probes.o file :
> $ dtrace -C -h -s probes.d -o probes.h
> $ dtrace -C -G -s probes.d -o probes.o
> [...]

It may be worthwhile to document an even-simpler case:

- no .d file
- no invocation of the dtrace python script
- no generated .h or .o file
- in the C file, just add:

  #include <sys/sdt.h>

  void main () {
       /* ... */
       STAP_PROBE(provider_name,probe_name);
       /* ... */
  }

- gcc file.c
- stap -l 'process("./a.out").mark("*")' to list


- FChE
