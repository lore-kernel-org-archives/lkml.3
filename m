Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966241Ab3HHTXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:23:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14390 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966189Ab3HHTXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:23:32 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=tvvMzHJ_TWIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XlcgNrZLg9MA:10 a=VnNF1IyMAAAA:8 a=Yng7hyX3xpuInTk1LSYA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 8 Aug 2013 15:23:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, bp@alien8.de, bhelgaas@google.com, rjw@sisk.pl,
        lance.ortiz@hp.com, m.chehab@samsung.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mce: acpi/apei: trace: Include PCIe AER trace event
 conditionally
Message-ID: <20130808152329.1f98b5e0@gandalf.local.home>
In-Reply-To: <1375986471-27113-2-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
	<1375986471-27113-2-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ attempting to try out claws-mail, hopefully this messages isn't
scrambled ;-) ]

On Thu,  8 Aug 2013 23:57:49 +0530
"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> wrote:

> Since we'll be adding multiple trace events to ras.h, we need to protect
> each block appropriately so that they only get included in the right
> places. Update PCIe AER trace event for this purpose.

Why not make a separate file for each? You will have to define
TRACE_EVENT_PCIE_AER for the users as well. That is, the places that
include ras.h and use the trace_aer_*() tracepoints.


> 
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---
>  drivers/pci/pcie/aer/aerdrv_errprint.c | 1 +
>  include/trace/events/ras.h             | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
> index 2c7c9f5..4d06859 100644
> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> @@ -24,6 +24,7 @@
>  #include "aerdrv.h"
>  
>  #define CREATE_TRACE_POINTS
> +#define TRACE_EVENT_PCIE_AER
>  #include <trace/events/ras.h>
>  
>  #define AER_AGENT_RECEIVER		0
> diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
> index 88b8783..4a66142 100644
> --- a/include/trace/events/ras.h
> +++ b/include/trace/events/ras.h
> @@ -1,7 +1,7 @@
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM ras
>  
> -#if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)
> +#if (!defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)) && defined()

I think it would look cleaner to encapsulate the one define with the
other:

#ifdef TRACE_EVENT_PCIE_AER
#if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)


-- Steve

>  #define _TRACE_AER_H
>  
>  #include <linux/tracepoint.h>

