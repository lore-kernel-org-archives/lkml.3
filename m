Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab3IRFZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 01:25:29 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36510 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3IRFZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 01:25:27 -0400
Message-ID: <52393904.4030800@linux.vnet.ibm.com>
Date: Wed, 18 Sep 2013 10:54:20 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/8][v4] powerpc/perf: Rename Power8 macros to start with
 PME
References: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com> <1379119755-21025-2-git-send-email-sukadev@linux.vnet.ibm.com>
In-Reply-To: <1379119755-21025-2-git-send-email-sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091805-3568-0000-0000-00000442DB3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2013 06:19 AM, Sukadev Bhattiprolu wrote:
> We use helpers like GENERIC_EVENT_ATTR() to list the generic events in
> sysfs. To avoid name collisions, GENERIC_EVENT_ATTR() requires the perf
> event macros to start with PME.

We got all the raw event codes covered for P7 with the help of power7-events-list.h
enumeration.

/*
 * Power7 event codes.
 */
#define EVENT(_name, _code) \
	PME_##_name = _code,

enum {
#include "power7-events-list.h"
};
#undef EVENT

Just wondering if its a good idea to name change these selected macros to be consumed
by GENERIC_EVENT_ATTR() right here for this purpose or we need to get the comprehensive
list of raw events for P8 first. Just an idea.

Regards
Anshuman

