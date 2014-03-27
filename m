Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaC0IpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:45:15 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:34994 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaC0IpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:45:06 -0400
Message-ID: <5333E50C.9090201@de.ibm.com>
Date: Thu, 27 Mar 2014 09:45:00 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@imap.linux.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] perf/tool: Fix usage of trace events with '-' in trace
 system name.
References: <87fvm411yi.wl%yarygin@imap.linux.ibm.com>
In-Reply-To: <87fvm411yi.wl%yarygin@imap.linux.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032708-4966-0000-0000-000008DE114C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/14 09:27, Alexander Yarygin wrote:
> 
> Trace events potentially can have a '-' in their trace system name,
> e.g. kvm on s390 defines kvm-s390:* tracepoints.
> tools/perf could not parse them, because there was no rule for this:
> $ sudo ./perf top -e "kvm-s390:*"
> invalid or unsupported event: 'kvm-s390:*'
> 
> This patch allows to '-' to be a part of PE_NAME token, so tracepoints
> with '-' can be parsed by the event_legacy_tracepoint rule.
> Without the patch, perf will not accept such tracepoints in the -e
> option.
> 
> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

When doing a V2, you should remove my Signed-off-by. ;-)



But at least we can now add my
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>


Ingo, Peter, Paul,

If you agree with this solution, I would like to have this in the next merge window - maybe 
cc stable if we consider perf stable relevant.

Christian


> ---
>  tools/perf/util/parse-events.l |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index 3432995..ca20da7 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -199,7 +199,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
>  {num_hex}		{ return value(yyscanner, 16); }
> 
>  {modifier_event}	{ return str(yyscanner, PE_MODIFIER_EVENT); }
> -{name}			{ return str(yyscanner, PE_NAME); }
> +{name_minus}			{ return str(yyscanner, PE_NAME); }
>  "/"			{ BEGIN(config); return '/'; }
>  -			{ return '-'; }
>  ,			{ BEGIN(event); return ','; }
> 

