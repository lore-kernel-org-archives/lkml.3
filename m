Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3JMIJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 04:09:30 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34547 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab3JMIJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 04:09:25 -0400
Message-ID: <525A5519.2050205@linux.vnet.ibm.com>
Date: Sun, 13 Oct 2013 13:38:57 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, x86@kernel.org,
        gleb@redhat.com, pbonzini@redhat.com, konrad.wilk@oracle.com,
        habanero@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, mtosatti@redhat.com,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] kvm fix: Enable pvspinlock after jump_label_init() to
 avoid VM hang
References: <y> <1381309401-23663-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
In-Reply-To: <1381309401-23663-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101308-9264-0000-0000-000004B472FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 02:33 PM, Raghavendra K T wrote:
> We use jump label to enable pv-spinlock. With the changes in
> (442e0973e927 Merge branch 'x86/jumplabel'), the jump label behaviour has changed
> that would result in evntual hang of the VM since we would end up in a situation
> where slowpath locks would halt the vcpus but we will not be able to wakeup the
> vcpu by lock releaser using unlock kick.
>
> Similar problem in Xen and more detailed description is available in
> a945928ea270 (xen: Do not enable spinlocks before jump_label_init() has executed)
>
> This patch splits kvm_spinlock_init to separate jump label changes with pvops
> patching and also make jump label enabling after jump_label_init().
>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Ingo,
Could you please take this fix?
This is reviewed by Paolo and Steven.

