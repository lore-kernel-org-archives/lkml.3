Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaEEKnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:43:22 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:33695 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbaEEKnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:43:20 -0400
Message-ID: <53676B40.1050609@de.ibm.com>
Date: Mon, 05 May 2014 12:43:12 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
CC: Paolo Bonzini <pbonzini@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 11/11] perf kvm: add stat support on s390
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com> <1398417153-57347-12-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1398417153-57347-12-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050510-4966-0000-0000-0000094824C8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 11:12, Christian Borntraeger wrote:
> +#if defined(__i386__) || defined(__x86_64__)
>  	else if (!strcmp(kvm->report_event, "mmio"))
>  		kvm->events_ops = &mmio_events;
>  	else if (!strcmp(kvm->report_event, "ioport"))
>  		kvm->events_ops = &ioport_events;
> +#endif

To address Davids review, the next version will have this hunk as well:

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 52276a6..e974749 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -103,8 +103,8 @@ STAT REPORT OPTIONS
        analyze events which occures on this vcpu. (default: all vcpus)
 
 --event=<value>::
-       event to be analyzed. Possible values: vmexit, mmio, ioport.
-       (default: vmexit)
+       event to be analyzed. Possible values: vmexit, mmio (x86 only),
+       ioport (x86 only). (default: vmexit)
 -k::
 --key=<value>::
        Sorting key. Possible values: sample (default, sort by samples

