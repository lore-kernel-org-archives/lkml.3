Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaLCORo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:17:44 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:57825 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaLCORn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:17:43 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 3 Dec 2014 09:17:46 -0500 (EST)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, gleb@redhat.com,
        joerg.roedel@amd.com
Subject: perf: exclude_hv vs exclude_host in perf_event_attr
Message-ID: <alpine.DEB.2.11.1412030907250.21872@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So what *is* the difference in perf_event_attr between
	.exclude_hv
and
	.exclude_guest
	.exclude_host

>From what I gather .exclude_hv excluces hypervisor counts if the hardware 
supports that type of measurement, but only Power implements this.

.exclude_guest and .exclude_host are x86 only?  AMD does them in hardware 
but it's implemented in software on Intel?
Do they only work when KVM is running, or do they tell you meaningful 
stuff otherwise?  What happens if I set them and KVM isn't running?

Also PEBS only will work if .exclude_guest is specified?


As always the code could use some commenting and the relevant commit 
messages aren't really that stellar either.

Vince Weaver
vincent.weaver@maine.edu
