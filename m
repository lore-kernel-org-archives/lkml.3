Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaCYKPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:15:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50775 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaCYKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:15:37 -0400
Message-ID: <53315741.9010508@redhat.com>
Date: Tue, 25 Mar 2014 11:15:29 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf/tool: Fix usage of trace events with '-' in trace
 system name.
References: <1395694140-43447-1-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1395694140-43447-1-git-send-email-borntraeger@de.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/03/2014 21:49, Christian Borntraeger ha scritto:
>  event_legacy_tracepoint:
> +PE_NAME '-' PE_NAME ':' PE_NAME
> +{
> +	struct parse_events_evlist *data = _data;
> +	struct list_head *list;
> +	char sys_name[strlen($1) + strlen($3) + 2];
> +	sprintf(&sys_name, "%s-%s", $1, $3);
> +
> +	ALLOC_LIST(list);
> +	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, &sys_name, $5));
> +	$$ = list;
> +}

Why isn't '-' part of PE_NAME?

Paolo
